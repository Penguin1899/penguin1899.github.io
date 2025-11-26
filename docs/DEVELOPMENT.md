# Development Workflow Guide

## Daily Development Workflow

### 1. Update Content
Edit the YAML files in the `data/` directory:

```bash
# Edit your personal information
vim data/personal.yml

# Update your skills
vim data/skills.yml

# Add new work experience  
vim data/experience.yml

# Add new projects
vim data/projects.yml

# Update contact information
vim data/contact.yml
```

### 2. Generate Site
```bash
# Activate virtual environment
source venv/bin/activate

# Generate HTML from templates and data
python generate_site.py
```

### 3. Preview Changes
Open `index.html` in your browser to preview your changes.

## Development Commands

### Python Environment
```bash
# Create virtual environment (first time only)
python3 -m venv venv

# Activate virtual environment
source venv/bin/activate

# Install/update dependencies
pip install -r requirements.txt

# Deactivate virtual environment
deactivate
```

### Site Generation
```bash
# Generate site
python generate_site.py

# Run with Python directly (if in venv)
python3 generate_site.py
```

### Code Quality
```bash
# Format Python code
black .

# Check formatting without changes
black --check --diff .

# Validate YAML files with yamllint
yamllint data/

# Validate specific file
yamllint data/personal.yml

# Validate with custom config
yamllint -c .yamllint.yml data/
```

### CSS Development (if Node.js is available)
```bash
# Install Node dependencies
npm install

# Build CSS once
npm run build-css

# Watch for changes and rebuild CSS
npm run watch-css

# Full build (CSS + HTML)
npm run build
```

## Quick Commands

### Full Build from Scratch
```bash
./build.sh
```

### Update and Rebuild
```bash
source venv/bin/activate
python generate_site.py
```

### Validate Everything
```bash
source venv/bin/activate

# Check YAML syntax and style
yamllint data/

# Check Python formatting
black --check .

# Generate site
python generate_site.py

# Validate HTML exists and has basic structure
test -f index.html && grep -q "<html" index.html && echo "✅ HTML OK"
```

## File Structure for Development

```
├── data/                   # Edit these files to update content
│   ├── personal.yml       # Your bio and personal info
│   ├── skills.yml         # Technical skills 
│   ├── experience.yml     # Work experience
│   ├── projects.yml       # Portfolio projects
│   └── contact.yml        # Contact and social links
├── index.mako            # Template file (rarely edited)
├── generate_site.py      # Build script (rarely edited)
└── index.html            # Generated output (don't edit directly)
```

## Common Tasks

### Adding a New Skill Category
1. Edit `data/skills.yml`
2. Add new category with items
3. Run `python generate_site.py`

### Adding a New Job
1. Edit `data/experience.yml`
2. Add new job entry to the `jobs` list
3. Run `python generate_site.py`

### Adding a New Project
1. Edit `data/projects.yml`
2. Add project under the appropriate company
3. Run `python generate_site.py`

### Updating Personal Information
1. Edit `data/personal.yml`
2. Update name, title, description, or bio
3. Run `python generate_site.py`

## Troubleshooting

### Python Issues
- **Import errors**: Make sure you're in the virtual environment (`source venv/bin/activate`)
- **YAML errors**: Check indentation (use spaces, not tabs)
- **Template errors**: Check that all YAML files exist and have required fields

### CSS Issues
- **Styles not loading**: Make sure `dist/output.css` exists or run `npm run build-css`
- **Styles look wrong**: Clear browser cache and reload

### Build Issues
- **Permission denied on build.sh**: Run `chmod +x build.sh`
- **Node.js not found**: Install Node.js or skip CSS building step

## Git Workflow

### Before Committing
```bash
# Format code
black .

# Generate latest site
python generate_site.py

# Add all changes
git add .

# Commit with descriptive message
git commit -m "Update portfolio content: add new project"

# Push to trigger deployment
git push origin main
```

The GitHub Actions workflow will automatically:
1. Validate your YAML files
2. Check Python code formatting
3. Test site generation
4. Deploy to GitHub Pages

## Tips

- Always test your changes locally before committing
- Use descriptive commit messages
- Keep YAML files properly indented (2 spaces)
- Validate YAML syntax before committing
- The generated `index.html` can be committed or ignored (see `.gitignore`)
