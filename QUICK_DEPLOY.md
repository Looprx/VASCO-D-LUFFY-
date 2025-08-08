# VASCO D LUFFY - Quick Deployment Guide

## 🚀 Fast Deployment Options

### Option 1: Vercel (Easiest)

```bash
# 1. Install Vercel CLI
npm i -g vercel

# 2. Login to Vercel
vercel login

# 3. Deploy
vercel --prod

# 4. Set environment variables in Vercel dashboard:
#    - DATABASE_URL: file:./db/custom.db
#    - NODE_ENV: production
#    - NEXT_PUBLIC_APP_URL: https://your-app.vercel.app
```

### Option 2: Railway

```bash
# 1. Install Railway CLI
npm install -g @railway/cli

# 2. Login
railway login

# 3. Initialize project
railway init

# 4. Deploy
railway up

# 5. Set environment variables in Railway dashboard
```

### Option 3: DigitalOcean App Platform

1. Push your code to GitHub
2. Go to DigitalOcean App Platform
3. Connect your GitHub repository
4. Configure:
   - Build Command: `npm run build`
   - Run Command: `npm start`
   - Environment Variables: Add from `.env.example`

### Option 4: Docker (Any Cloud)

```bash
# Build and run with Docker
docker build -t vascodluffy .
docker run -d -p 3000:3000 --name vascodluffy-app vascodluffy

# Or use docker-compose
docker-compose up -d
```

## 📋 Pre-Deployment Checklist

- [ ] Environment variables configured
- [ ] Database setup script tested
- [ ] All dependencies installed
- [ ] Code passes linting (`npm run lint`)
- [ ] Production build configuration optimized

## 🔧 Environment Variables Required

```env
DATABASE_URL="file:./db/custom.db"
NODE_ENV="production"
NEXT_PUBLIC_APP_URL="https://your-domain.com"
NEXT_PUBLIC_APP_NAME="VASCO D LUFFY Drug Safety Platform"
```

## 🚨 Important Notes

1. **Database**: The app uses SQLite by default. For production, consider PostgreSQL
2. **Security**: Always use HTTPS in production
3. **Backups**: Set up automated database backups
4. **Monitoring**: Configure health checks and monitoring

## 📚 Full Documentation

See `DEPLOYMENT.md` for comprehensive deployment instructions including:
- VPS deployment with Nginx
- AWS EC2 setup
- Heroku deployment
- Database migration guides
- Security configurations
- Backup strategies

## 🎯 Post-Deployment

1. **Health Check**: Visit `https://your-domain.com/api/health`
2. **Test Features**: Try medication interaction checker
3. **Monitor Logs**: Check application logs for errors
4. **Set Up Monitoring**: Configure uptime monitoring

## 🆘 Support

If you encounter issues:
1. Check the troubleshooting section in `DEPLOYMENT.md`
2. Review application logs
3. Ensure all environment variables are set correctly
4. Verify database connectivity

---

**Ready to deploy!** 🎉