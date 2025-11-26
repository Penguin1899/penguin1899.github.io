#!/bin/bash

# Portfolio Site Build Script
# This script automates the build process for the portfolio site

set -e  # Exit on any error

echo "🚀 Portfolio Site Build Script"
echo "==============================="

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "📦 Creating Python virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
echo "🔧 Activating virtual environment..."
source venv/bin/activate

# Install/update Python dependencies
echo "📥 Installing Python dependencies..."
pip install -r requirements.txt

# Generate the site
echo "🏗️  Generating website from templates and data..."
python generate_site.py

# Generate the resume PDF
echo "📄 Generating resume PDF..."
if command -v pdflatex &> /dev/null; then
    python generate_resume.py
    if [ -f "resume.pdf" ]; then
        echo "✅ Resume PDF generated successfully!"
    else
        echo "⚠️  Resume PDF generation failed - check LaTeX installation"
    fi
else
    echo "⚠️  pdflatex not found. Skipping resume PDF generation."
    echo "💡 Install LaTeX (MacTeX/MiKTeX/texlive) to enable PDF generation."
fi

# Check if Node.js is available for CSS building
if command -v npm &> /dev/null; then
    echo "🎨 Building CSS with Tailwind..."
    npm install
    npm run build-css
else
    echo "⚠️  npm not found. Skipping CSS build."
    echo "💡 Install Node.js to enable CSS compilation, or use existing CSS."
fi

# Validate the generated outputs
if [ -f "index.html" ]; then
    echo "✅ Website generated successfully!"
    echo "📁 Output: index.html"
    
    # Basic validation
    if grep -q "<html" index.html && grep -q "</html>" index.html; then
        echo "✅ HTML structure looks valid"
    else
        echo "⚠️  HTML structure might have issues"
    fi
else
    echo "❌ Failed to generate index.html"
    exit 1
fi

echo ""
echo "🎉 Build completed!"
echo "📖 Open index.html in your browser to view the site"
if [ -f "resume.pdf" ]; then
    echo "� Open resume.pdf to view your resume"
fi
echo "�🔄 Run 'python generate_site.py' after updating data files"
echo "🔄 Run 'python generate_resume.py' after updating resume data"
