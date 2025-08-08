# VASCO D LUFFY Drug Safety Platform - Deployment Guide

## Overview

This guide provides comprehensive instructions for deploying the VASCO D LUFFY Drug Safety Platform to production environments. The platform is built with Next.js, TypeScript, and Prisma, using SQLite as the database.

## Prerequisites

Before deploying, ensure you have the following:

- **Node.js** 18.x or higher
- **npm** or yarn package manager
- **Git** for version control
- **Docker** (optional, for containerized deployment)
- **Domain name** (for production deployment)
- **SSL certificate** (recommended for production)

## Environment Configuration

### 1. Environment Variables

Create a `.env` file based on `.env.example`:

```bash
cp .env.example .env
```

Configure the essential environment variables:

```env
# Database Configuration
DATABASE_URL="file:./db/custom.db"

# Application Configuration
NODE_ENV="production"
NEXT_PUBLIC_APP_URL="https://your-domain.com"
NEXT_PUBLIC_APP_NAME="VASCO D LUFFY Drug Safety Platform"

# Security
NEXTAUTH_SECRET="generate-a-secure-secret-here"
NEXTAUTH_URL="https://your-domain.com"
```

### 2. Generate Security Secrets

Generate secure secrets for production:

```bash
# Generate NextAuth secret
openssl rand -base64 32
```

## Deployment Methods

### Method 1: Direct Deployment (Recommended for VPS)

#### Step 1: Clone the Repository

```bash
git clone <your-repository-url>
cd vascodluffy-drug-safety-platform
```

#### Step 2: Install Dependencies

```bash
npm ci --production=false
```

#### Step 3: Setup Database

```bash
# Setup production database
npm run setup:db

# Or run the setup script directly
npx tsx scripts/setup-production-db.ts
```

#### Step 4: Build the Application

```bash
npm run build
```

#### Step 5: Start the Application

```bash
# Using PM2 (recommended)
npm install -g pm2
pm2 start server.ts --name drug-safety-platform --time

# Or directly
npm start
```

#### Step 6: Configure Reverse Proxy (Nginx)

Create an Nginx configuration file:

```nginx
server {
    listen 80;
    server_name your-domain.com www.your-domain.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name your-domain.com www.your-domain.com;
    
    ssl_certificate /path/to/your/certificate.crt;
    ssl_certificate_key /path/to/your/private.key;
    
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
    
    # WebSocket support for Socket.IO
    location /api/socketio/ {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### Method 2: Docker Deployment

#### Step 1: Build Docker Image

```bash
docker build -t drug-safety-platform:latest .
```

#### Step 2: Run with Docker Compose

```bash
# Start the application
docker-compose up -d

# View logs
docker-compose logs -f app

# Stop the application
docker-compose down
```

#### Step 3: Docker Compose with Nginx

Create a `docker-compose.prod.yml`:

```yaml
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    environment:
      - NODE_ENV=production
      - DATABASE_URL=file:./db/custom.db
      - NEXT_PUBLIC_APP_URL=https://your-domain.com
      - NEXT_PUBLIC_APP_NAME=VASCO D LUFFY Drug Safety Platform
    volumes:
      - ./db:/app/db
    restart: unless-stopped
    networks:
      - app-network

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl
    depends_on:
      - app
    restart: unless-stopped
    networks:
      - app-network

networks:
  app-network:
    driver: bridge
```

### Method 3: Cloud Platform Deployment

#### Vercel Deployment

1. **Connect to Vercel:**
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

#### AWS EC2 Deployment

1. **Launch EC2 Instance:**
   - Choose Ubuntu 20.04 LTS
   - Configure security groups (ports 22, 80, 443)
   - Attach IAM role with necessary permissions

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

#### Heroku Deployment

1. **Install Heroku CLI:**
   ```bash
   npm install -g heroku
   heroku login
   ```

2. **Create Heroku App:**
   ```bash
   heroku create your-app-name
   ```

3. **Add Buildpacks:**
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

## Database Management

### SQLite Database

The platform uses SQLite for simplicity. The database file is located at `./db/custom.db`.

#### Backup Database

```bash
# Create backup
cp ./db/custom.db ./db/custom.db.backup.$(date +%Y%m%d_%H%M%S)

# Compress backup
gzip ./db/custom.db.backup.$(date +%Y%m%d_%H%M%S)
```

#### Restore Database

```bash
# Stop application
pm2 stop drug-safety-platform

# Restore from backup
cp ./db/custom.db.backup ./db/custom.db

# Start application
pm2 start drug-safety-platform
```

### Migration to PostgreSQL (Optional)

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

## Monitoring and Maintenance

### Application Monitoring

#### Health Check

The application includes a health check endpoint:

```bash
curl http://localhost:3000/api/health
```

#### Log Management

```bash
# View application logs
pm2 logs drug-safety-platform

# View system logs
tail -f /var/log/nginx/error.log
```

#### Performance Monitoring

Consider integrating with:
- **Sentry** for error tracking
- **New Relic** for performance monitoring
- **Google Analytics** for user analytics

### Security Considerations

1. **SSL/TLS:**
   - Always use HTTPS in production
   - Configure proper SSL certificates
   - Use strong cipher suites

2. **Headers:**
   - Security headers are configured in `next.config.ts`
   - Consider additional headers like CSP

3. **Rate Limiting:**
   - Implement rate limiting for API endpoints
   - Use middleware to prevent abuse

4. **Database Security:**
   - Regular database backups
   - Proper file permissions
   - Database encryption if sensitive data

### Backup Strategy

1. **Automated Backups:**
   ```bash
   # Create backup script
   cat > /usr/local/bin/backup-db.sh << 'EOF'
   #!/bin/bash
   DATE=$(date +%Y%m%d_%H%M%S)
   cp /path/to/app/db/custom.db /backups/custom.db.$DATE
   gzip /backups/custom.db.$DATE
   # Keep only last 7 days of backups
   find /backups -name "custom.db.*.gz" -mtime +7 -delete
   EOF
   
   chmod +x /usr/local/bin/backup-db.sh
   ```

2. **Cron Job:**
   ```bash
   # Add to crontab
   0 2 * * * /usr/local/bin/backup-db.sh
   ```

## Troubleshooting

### Common Issues

#### 1. Database Connection Issues

```bash
# Check database file exists
ls -la ./db/custom.db

# Check permissions
chmod 644 ./db/custom.db

# Verify database URL
echo $DATABASE_URL
```

#### 2. Port Already in Use

```bash
# Find process using port 3000
lsof -ti:3000

# Kill the process
kill -9 <PID>
```

#### 3. Memory Issues

```bash
# Check memory usage
free -h

# Monitor Node.js memory
pm2 monit
```

#### 4. Build Failures

```bash
# Clean build
rm -rf .next node_modules
npm ci
npm run build
```

### Performance Optimization

1. **Enable Compression:**
   ```nginx
   gzip on;
   gzip_vary on;
   gzip_min_length 1024;
   gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json;
   ```

2. **Caching:**
   - Configure browser caching for static assets
   - Consider Redis for session storage

3. **Database Optimization:**
   - Regular database maintenance
   - Index optimization

## Support

For deployment issues or questions:

1. Check the troubleshooting section
2. Review application logs
3. Consult the project documentation
4. Contact the development team

---

**Note:** This deployment guide is continuously updated. For the latest version, please check the repository documentation.