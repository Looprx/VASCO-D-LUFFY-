#!/bin/bash

# VASCO D LUFFY - Vercel Deployment Script
# Automated deployment to Vercel platform

set -e

echo "🚀 Starting VASCO D LUFFY Vercel Deployment..."

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

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check if Vercel CLI is installed
    if ! command -v vercel &> /dev/null; then
        log_error "Vercel CLI is not installed"
        echo "Installing Vercel CLI..."
        npm install -g vercel
    fi
    
    # Check if logged in to Vercel
    if ! vercel whoami &> /dev/null; then
        log_error "Not logged in to Vercel"
        echo "Please login to Vercel:"
        vercel login
        exit 1
    fi
    
    # Check if git repository is initialized
    if [ ! -d ".git" ]; then
        log_error "Git repository not initialized"
        echo "Initializing git repository..."
        git init
        git add .
        git commit -m "Initial commit"
    fi
    
    # Check if package.json exists
    if [ ! -f "package.json" ]; then
        log_error "package.json not found"
        exit 1
    fi
    
    log_info "Prerequisites check passed"
}

# Prepare for deployment
prepare_deployment() {
    log_info "Preparing for deployment..."
    
    # Install dependencies
    log_info "Installing dependencies..."
    npm ci
    
    # Test build locally
    log_info "Testing build locally..."
    if npm run build; then
        log_info "Build test passed"
    else
        log_error "Build test failed"
        exit 1
    fi
    
    # Commit any changes
    log_info "Committing changes..."
    git add .
    git commit -m "Prepare for Vercel deployment" || log_warn "No changes to commit"
    
    # Push to remote
    log_info "Pushing to remote repository..."
    git push origin main || git push origin master || log_warn "No remote configured or push failed"
    
    log_info "Deployment preparation completed"
}

# Deploy to Vercel
deploy_to_vercel() {
    log_info "Deploying to Vercel..."
    
    # Deploy to production
    if vercel --prod --yes; then
        log_info "Deployment initiated successfully"
    else
        log_error "Deployment failed"
        exit 1
    fi
    
    # Get deployment URL
    DEPLOYMENT_URL=$(vercel ls --prod 2>/dev/null | head -1 | awk '{print $2}')
    
    if [ -n "$DEPLOYMENT_URL" ]; then
        log_info "Deployment URL: https://$DEPLOYMENT_URL"
    else
        log_warn "Could not get deployment URL"
    fi
}

# Set up environment variables
setup_environment() {
    log_info "Setting up environment variables..."
    
    # Check if .env.vercel exists
    if [ -f ".env.vercel" ]; then
        log_info "Found .env.vercel file"
        echo "Please ensure the following environment variables are set in your Vercel dashboard:"
        echo ""
        cat .env.vercel
        echo ""
        log_warn "Visit your Vercel dashboard to set these variables"
    else
        log_warn "No .env.vercel file found"
        echo "Create a .env.vercel file with your environment variables"
    fi
}

# Test deployment
test_deployment() {
    log_info "Testing deployment..."
    
    # Get deployment URL
    DEPLOYMENT_URL=$(vercel ls --prod 2>/dev/null | head -1 | awk '{print $2}')
    
    if [ -z "$DEPLOYMENT_URL" ]; then
        log_error "Could not get deployment URL"
        return
    fi
    
    # Wait for deployment to be ready
    log_info "Waiting for deployment to be ready..."
    sleep 30
    
    # Test health endpoint
    log_info "Testing health endpoint..."
    if curl -s "https://$DEPLOYMENT_URL/api/health" | grep -q "healthy"; then
        log_info "Health endpoint test passed"
    else
        log_warn "Health endpoint test failed"
    fi
    
    # Test medications endpoint
    log_info "Testing medications endpoint..."
    if curl -s "https://$DEPLOYMENT_URL/api/medications" | grep -q "medications"; then
        log_info "Medications endpoint test passed"
    else
        log_warn "Medications endpoint test failed"
    fi
    
    # Test interactions endpoint
    log_info "Testing interactions endpoint..."
    if curl -s -X POST "https://$DEPLOYMENT_URL/api/interactions" \
        -H "Content-Type: application/json" \
        -d '{"medicationIds": ["1", "2"]}' | grep -q "severity"; then
        log_info "Interactions endpoint test passed"
    else
        log_warn "Interactions endpoint test failed"
    fi
    
    log_info "Deployment testing completed"
}

# Main deployment process
main() {
    log_info "Starting VASCO D LUFFY Vercel deployment process"
    
    check_prerequisites
    prepare_deployment
    setup_environment
    deploy_to_vercel
    test_deployment
    
    log_info "🎉 Vercel deployment completed successfully!"
    log_info ""
    log_info "Next steps:"
    log_info "1. Set up environment variables in Vercel dashboard"
    log_info "2. Configure custom domain if needed"
    log_info "3. Set up monitoring and analytics"
    log_info "4. Test all features thoroughly"
    log_info ""
    DEPLOYMENT_URL=$(vercel ls --prod 2>/dev/null | head -1 | awk '{print $2}')
    if [ -n "$DEPLOYMENT_URL" ]; then
        log_info "Your application is available at: https://$DEPLOYMENT_URL"
    fi
}

# Handle script interruption
trap 'log_error "Deployment interrupted"; exit 1' INT TERM

# Run main function
main "$@"