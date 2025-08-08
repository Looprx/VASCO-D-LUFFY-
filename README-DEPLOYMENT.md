# VASCO D LUFFY Drug Safety Platform - Deployment Guide

## 🚀 Quick Start

### Prerequisites

- **Node.js** 18.x or higher
- **npm** or yarn package manager
- **Git** for version control
- **Server with SSH access** (for production deployment)
- **Domain name** (for production)
- **SSL certificate** (automated with Let's Encrypt)

### 1. Local Development Setup

```bash
# Clone the repository
git clone <your-repository-url>
cd vascodluffy-drug-safety-platform

# Install dependencies
npm install

# Setup database
npm run setup:db

# Start development server
npm run dev
```

### 2. Production Deployment

#### Option A: Automated Deployment (Recommended)

```bash
# Configure your server details in deploy.sh
# Edit the following variables:
# - DEPLOY_HOST="your-server-ip"
# - DOMAIN="your-domain.com"
# - DEPLOY_USER="deploy"

# Run the deployment script
./deploy.sh
```

#### Option B: Manual Deployment

##### Step 1: Prepare the Application

```bash
# Build the application
npm run build

# Create production environment file
cp .env.example .env.production
# Edit .env.production with your production settings
```

##### Step 2: Server Setup

```bash
# Connect to your server
ssh your-user@your-server-ip

# Install Node.js and npm
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install Nginx
sudo apt update
sudo apt install nginx

# Install PM2 (optional, for process management)
npm install -g pm2
```

##### Step 3: Deploy Files

```bash
# Copy files to server
scp -r .next/ db/ prisma/ package.json package-lock.json server.ts .env.production your-user@your-server-ip:/var/www/vasco-d-luffy/

# Connect to server
ssh your-user@your-server-ip
cd /var/www/vasco-d-luffy

# Install dependencies
npm ci --production

# Setup database
npx prisma generate
npx tsx prisma/seed.ts

# Start the application
npm start
```

##### Step 4: Configure Nginx

Create Nginx configuration:

```nginx
server {
    listen 80;
    server_name your-domain.com www.your-domain.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name your-domain.com www.your-domain.com;
    
    ssl_certificate /etc/letsencrypt/live/your-domain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/your-domain.com/privkey.pem;
    
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
```

##### Step 5: Setup SSL

```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx

# Obtain SSL certificate
sudo certbot --nginx -d your-domain.com -d www.your-domain.com
```

## 🐳 Docker Deployment

### Using Docker Compose

```bash
# Build and start the application
docker-compose up -d

# View logs
docker-compose logs -f

# Stop the application
docker-compose down
```

### Manual Docker Commands

```bash
# Build Docker image
docker build -t drug-safety-platform:latest .

# Run container
docker run -d \
  --name drug-safety-platform \
  -p 3000:3000 \
  -v $(pwd)/db:/app/db \
  -e NODE_ENV=production \
  -e DATABASE_URL="file:./db/custom.db" \
  drug-safety-platform:latest
```

## ☁️ Cloud Platform Deployment

### Vercel Deployment

1. **Install Vercel CLI:**
   ```bash
   npm install -g vercel
   vercel login
   ```

2. **Deploy:**
   ```bash
   vercel --prod
   ```

3. **Configure Environment Variables:**
   - Go to Vercel dashboard
   - Add environment variables in project settings
   - Redeploy

### Heroku Deployment

1. **Install Heroku CLI:**
   ```bash
   npm install -g heroku
   heroku login
   ```

2. **Create App:**
   ```bash
   heroku create your-app-name
   ```

3. **Add Buildpack:**
   ```bash
   heroku buildpacks:set heroku/nodejs
   ```

4. **Set Environment Variables:**
   ```bash
   heroku config:set NODE_ENV=production
   heroku config:set NEXT_PUBLIC_APP_URL=https://your-app-name.herokuapp.com
   ```

5. **Deploy:**
   ```bash
   git push heroku main
   ```

### AWS EC2 Deployment

1. **Launch EC2 Instance:**
   - Choose Ubuntu 20.04 LTS
   - Configure security groups (ports 22, 80, 443)
   - Attach IAM role

2. **Install Dependencies:**
   ```bash
   sudo apt update
   sudo apt install -y nodejs npm nginx
   ```

3. **Deploy Application:**
   ```bash
   git clone <repository>
   cd vascodluffy-drug-safety-platform
   npm ci
   npm run setup:db
   npm run build
   ```

4. **Configure Nginx and SSL:**
   ```bash
   sudo certbot --nginx -d your-domain.com
   ```

## 📊 Monitoring and Maintenance

### Application Health Check

```bash
# Check if application is running
curl https://your-domain.com/api/health

# Check application logs
ssh your-user@your-server-ip 'journalctl -u vasco-d-luffy -f'

# Check Nginx logs
ssh your-user@your-server-ip 'journalctl -u nginx -f'
```

### Database Management

#### Backup Database

```bash
# Create backup
ssh your-user@your-server-ip 'cp /var/www/vasco-d-luffy/db/custom.db /var/www/vasco-d-luffy/db/custom.db.backup.$(date +%Y%m%d_%H%M%S)'

# Download backup
scp your-user@your-server-ip:/var/www/vasco-d-luffy/db/custom.db.backup.* .
```

#### Restore Database

```bash
# Stop application
ssh your-user@your-server-ip 'systemctl stop vasco-d-luffy'

# Restore backup
scp custom.db.backup your-user@your-server-ip:/var/www/vasco-d-luffy/db/custom.db

# Start application
ssh your-user@your-server-ip 'systemctl start vasco-d-luffy'
```

### Systemd Service Management

```bash
# Start service
sudo systemctl start vasco-d-luffy

# Stop service
sudo systemctl stop vasco-d-luffy

# Restart service
sudo systemctl restart vasco-d-luffy

# Check status
sudo systemctl status vasco-d-luffy

# Enable auto-start on boot
sudo systemctl enable vasco-d-luffy
```

## 🔧 Configuration

### Environment Variables

Create a `.env.production` file:

```env
# Application Configuration
NODE_ENV=production
PORT=3000
HOSTNAME=0.0.0.0

# Database Configuration
DATABASE_URL="file:./db/custom.db"

# Application URLs
NEXT_PUBLIC_APP_URL="https://your-domain.com"
NEXT_PUBLIC_APP_NAME="VASCO D LUFFY Drug Safety Platform"

# Security
NEXTAUTH_SECRET="generate-a-secure-secret-here"
NEXTAUTH_URL="https://your-domain.com"

# Optional Services
NEXT_PUBLIC_GOOGLE_ANALYTICS_ID=""
NEXT_PUBLIC_SENTRY_DSN=""
ZAI_API_KEY=""
```

### Database Configuration

#### SQLite (Default)

The platform uses SQLite by default. The database file is located at `./db/custom.db`.

#### PostgreSQL (Optional)

For larger deployments, you can migrate to PostgreSQL:

1. **Update `.env`:**
   ```env
   DATABASE_URL="postgresql://user:password@host:port/database"
   ```

2. **Update Prisma Schema:**
   ```prisma
   datasource db {
     provider = "postgresql"
     url      = env("DATABASE_URL")
   }
   ```

3. **Run Migration:**
   ```bash
   npx prisma migrate dev
   ```

## 🚨 Troubleshooting

### Common Issues

#### 1. Port Already in Use

```bash
# Find process using port 3000
lsof -ti:3000

# Kill the process
kill -9 <PID>
```

#### 2. Database Connection Issues

```bash
# Check database file exists
ls -la ./db/custom.db

# Check permissions
chmod 644 ./db/custom.db

# Verify database URL
echo $DATABASE_URL
```

#### 3. Build Failures

```bash
# Clean build
rm -rf .next node_modules
npm ci
npm run build
```

#### 4. SSL Certificate Issues

```bash
# Check certificate status
sudo certbot certificates

# Renew certificate
sudo certbot renew

# Test Nginx configuration
sudo nginx -t
```

### Performance Issues

#### 1. High Memory Usage

```bash
# Check memory usage
free -h

# Monitor Node.js memory
pm2 monit
```

#### 2. Slow Response Times

```bash
# Check application logs
journalctl -u vasco-d-luffy -f

# Check Nginx access logs
tail -f /var/log/nginx/access.log

# Monitor system resources
htop
```

## 📈 Performance Optimization

### Application Optimization

1. **Enable Compression:**
   ```nginx
   gzip on;
   gzip_vary on;
   gzip_min_length 1024;
   gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json;
   ```

2. **Configure Caching:**
   ```nginx
   # Static files
   location /_next/static/ {
     expires 1y;
     add_header Cache-Control "public, immutable";
   }
   ```

3. **Database Optimization:**
   - Regular database maintenance
   - Index optimization
   - Connection pooling

### Server Optimization

1. **System Optimization:**
   ```bash
   # Increase file descriptor limit
   echo "* soft nofile 65536" >> /etc/security/limits.conf
   echo "* hard nofile 65536" >> /etc/security/limits.conf
   ```

2. **Nginx Optimization:**
   ```nginx
   worker_processes auto;
   worker_connections 1024;
   keepalive_timeout 65;
   ```

## 🔒 Security Considerations

### Application Security

1. **Environment Variables:**
   - Never commit `.env` files to version control
   - Use strong secrets
   - Rotate secrets regularly

2. **Headers:**
   - Security headers are configured in `next.config.ts`
   - Consider additional headers like CSP

3. **Rate Limiting:**
   - Implement rate limiting for API endpoints
   - Use fail2ban for brute force protection

### Server Security

1. **Firewall Configuration:**
   ```bash
   # Allow only necessary ports
   sudo ufw allow 22/tcp
   sudo ufw allow 80/tcp
   sudo ufw allow 443/tcp
   sudo ufw enable
   ```

2. **User Management:**
   - Use non-root user for application
   - Restrict SSH access
   - Use key-based authentication

3. **Regular Updates:**
   ```bash
   sudo apt update
   sudo apt upgrade
   ```

## 📞 Support

For deployment issues or questions:

1. Check the troubleshooting section
2. Review application logs
3. Consult the project documentation
4. Check GitHub issues
5. Contact the development team

---

**Note:** This deployment guide is continuously updated. For the latest version, please check the repository documentation.