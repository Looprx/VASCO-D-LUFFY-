#!/bin/bash

# VASCO D LUFFY Drug Safety Platform - Production Deployment Script
# This script handles the complete deployment process

set -e

echo "🚀 Starting VASCO D LUFFY Production Deployment..."

# Configuration
APP_NAME="vasco-d-luffy"
DEPLOY_USER="deploy"
DEPLOY_HOST="your-server-ip"
DEPLOY_PATH="/var/www/${APP_NAME}"
DOMAIN="your-domain.com"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we have all required files
check_prerequisites() {
    log_info "Checking deployment prerequisites..."
    
    if [ ! -f "package.json" ]; then
        log_error "package.json not found. Please run this script from the project root."
        exit 1
    fi
    
    if [ ! -f ".env.production" ]; then
        log_error ".env.production not found. Please create it from .env.example"
        exit 1
    fi
    
    log_info "Prerequisites check passed"
}

# Build the application
build_application() {
    log_info "Building application..."
    
    # Install dependencies
    npm ci --production=false
    
    # Copy production environment
    cp .env.production .env
    
    # Generate Prisma client
    npx prisma generate
    
    # Build the application
    npm run build
    
    if [ $? -eq 0 ]; then
        log_info "Application built successfully"
    else
        log_error "Build failed"
        exit 1
    fi
}

# Create deployment package
create_package() {
    log_info "Creating deployment package..."
    
    # Create temporary directory
    PACKAGE_DIR="deploy-package"
    rm -rf ${PACKAGE_DIR}
    mkdir -p ${PACKAGE_DIR}
    
    # Copy necessary files
    cp -r .next ${PACKAGE_DIR}/
    cp -r public ${PACKAGE_DIR}/
    cp -r db ${PACKAGE_DIR}/
    cp -r prisma ${PACKAGE_DIR}/
    cp package.json ${PACKAGE_DIR}/
    cp package-lock.json ${PACKAGE_DIR}/
    cp server.ts ${PACKAGE_DIR}/
    cp .env ${PACKAGE_DIR}/
    
    # Create deployment script
    cat > ${PACKAGE_DIR}/start.sh << 'EOF'
#!/bin/bash
cd /var/www/vasco-d-luffy

# Install production dependencies
npm ci --production

# Setup database
npx prisma generate
if [ ! -f "db/custom.db" ]; then
    npx tsx prisma/seed.ts
fi

# Start the application
NODE_ENV=production npx tsx server.ts
EOF
    
    chmod +x ${PACKAGE_DIR}/start.sh
    
    # Create tarball
    tar -czf ${APP_NAME}-deploy.tar.gz -C ${PACKAGE_DIR} .
    
    log_info "Deployment package created: ${APP_NAME}-deploy.tar.gz"
}

# Deploy to server
deploy_to_server() {
    log_info "Deploying to server..."
    
    # Check if we can connect to the server
    if ! ssh -o BatchMode=yes -o ConnectTimeout=5 ${DEPLOY_USER}@${DEPLOY_HOST} exit 2>/dev/null; then
        log_error "Cannot connect to server ${DEPLOY_HOST} as user ${DEPLOY_USER}"
        log_info "Please ensure:"
        log_info "1. SSH key is set up correctly"
        log_info "2. Server is accessible"
        log_info "3. User ${DEPLOY_USER} exists on the server"
        exit 1
    fi
    
    # Create deployment directory on server
    ssh ${DEPLOY_USER}@${DEPLOY_HOST} "sudo mkdir -p ${DEPLOY_PATH} && sudo chown ${DEPLOY_USER}:${DEPLOY_USER} ${DEPLOY_PATH}"
    
    # Copy deployment package
    scp ${APP_NAME}-deploy.tar.gz ${DEPLOY_USER}@${DEPLOY_HOST}:/tmp/
    
    # Extract and setup on server
    ssh ${DEPLOY_USER}@${DEPLOY_HOST} "
        cd ${DEPLOY_PATH} &&
        tar -xzf /tmp/${APP_NAME}-deploy.tar.gz &&
        rm /tmp/${APP_NAME}-deploy.tar.gz &&
        chmod +x start.sh
    "
    
    log_info "Files deployed to server"
}

# Setup systemd service
setup_systemd_service() {
    log_info "Setting up systemd service..."
    
    # Create systemd service file
    ssh ${DEPLOY_USER}@${DEPLOY_HOST} "sudo tee /etc/systemd/system/${APP_NAME}.service > /dev/null << 'EOF'
[Unit]
Description=VASCO D LUFFY Drug Safety Platform
After=network.target

[Service]
Type=simple
User=${DEPLOY_USER}
WorkingDirectory=${DEPLOY_PATH}
ExecStart=${DEPLOY_PATH}/start.sh
Restart=always
RestartSec=10
Environment=NODE_ENV=production
Environment=PORT=3000
Environment=HOSTNAME=0.0.0.0

[Install]
WantedBy=multi-user.target
EOF"
    
    # Reload systemd and enable service
    ssh ${DEPLOY_USER}@${DEPLOY_HOST} "
        sudo systemctl daemon-reload &&
        sudo systemctl enable ${APP_NAME} &&
        sudo systemctl start ${APP_NAME}
    "
    
    log_info "Systemd service configured and started"
}

# Setup Nginx reverse proxy
setup_nginx() {
    log_info "Setting up Nginx reverse proxy..."
    
    # Create Nginx configuration
    ssh ${DEPLOY_USER}@${DEPLOY_HOST} "sudo tee /etc/nginx/sites-available/${APP_NAME} > /dev/null << 'EOF'
server {
    listen 80;
    server_name ${DOMAIN} www.${DOMAIN};
    return 301 https://\$server_name\$request_uri;
}

server {
    listen 443 ssl http2;
    server_name ${DOMAIN} www.${DOMAIN};
    
    ssl_certificate /etc/letsencrypt/live/${DOMAIN}/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/${DOMAIN}/privkey.pem;
    
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;
    
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
    }
    
    location /api/socketio/ {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection \"upgrade\";
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
    
    # Static files caching
    location /_next/static/ {
        alias ${DEPLOY_PATH}/.next/static/;
        expires 1y;
        add_header Cache-Control \"public, immutable\";
    }
    
    # Security headers
    add_header X-Frame-Options \"SAMEORIGIN\" always;
    add_header X-Content-Type-Options \"nosniff\" always;
    add_header X-XSS-Protection \"1; mode=block\" always;
    add_header Referrer-Policy \"strict-origin-when-cross-origin\" always;
}
EOF"
    
    # Enable site and test Nginx configuration
    ssh ${DEPLOY_USER}@${DEPLOY_HOST} "
        sudo ln -sf /etc/nginx/sites-available/${APP_NAME} /etc/nginx/sites-enabled/ &&
        sudo nginx -t
    "
    
    if [ $? -eq 0 ]; then
        log_info "Nginx configuration is valid"
    else
        log_error "Nginx configuration test failed"
        exit 1
    fi
    
    # Reload Nginx
    ssh ${DEPLOY_USER}@${DEPLOY_HOST} "sudo systemctl reload nginx"
    
    log_info "Nginx reverse proxy configured"
}

# Setup SSL certificate
setup_ssl() {
    log_info "Setting up SSL certificate..."
    
    # Install certbot if not present
    ssh ${DEPLOY_USER}@${DEPLOY_HOST} "
        if ! command -v certbot &> /dev/null; then
            sudo apt update &&
            sudo apt install -y certbot python3-certbot-nginx
        fi
    "
    
    # Obtain SSL certificate
    ssh ${DEPLOY_USER}@${DEPLOY_HOST} "
        sudo certbot --nginx -d ${DOMAIN} -d www.${DOMAIN} --non-interactive --agree-tos --email admin@${DOMAIN}
    "
    
    log_info "SSL certificate obtained and configured"
}

# Health check
health_check() {
    log_info "Performing health check..."
    
    # Wait for application to start
    sleep 30
    
    # Check if application is responding
    if curl -f https://${DOMAIN}/api/health > /dev/null 2>&1; then
        log_info "Health check passed - application is running"
    else
        log_error "Health check failed - application may not be running properly"
        exit 1
    fi
}

# Main deployment process
main() {
    log_info "Starting production deployment for ${APP_NAME}"
    
    check_prerequisites
    build_application
    create_package
    deploy_to_server
    setup_systemd_service
    setup_nginx
    setup_ssl
    health_check
    
    log_info "🎉 Production deployment completed successfully!"
    log_info "Application is running at: https://${DOMAIN}"
    log_info ""
    log_info "Post-deployment tasks:"
    log_info "1. Monitor application logs: ssh ${DEPLOY_USER}@${DEPLOY_HOST} 'journalctl -u ${APP_NAME} -f'"
    log_info "2. Check service status: ssh ${DEPLOY_USER}@${DEPLOY_HOST} 'systemctl status ${APP_NAME}'"
    log_info "3. View Nginx logs: ssh ${DEPLOY_USER}@${DEPLOY_HOST} 'journalctl -u nginx -f'"
    log_info "4. Setup database backups: ssh ${DEPLOY_USER}@${DEPLOY_HOST} 'crontab -e'"
}

# Handle script interruption
trap 'log_error "Deployment interrupted"; exit 1' INT TERM

# Run main function
main "$@"