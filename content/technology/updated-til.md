Title: Updated TIL
Date: 2025-06-05
Author: ryan
Tags: til, claude, 
Slug: updated-til
Status: published

While browsing Mastodon the other day I came across a toot that linked to this [Cursed Knowledge](https://immich.app/cursed-knowledge/) page. I thought it was a great page, but it occurred to me that it could be helpful to apply the same sort of styling to my TIL Repo. 

My [TIL](https://github.com/ryancheley/til) (Today I Learned) repository was inspired by [Simon Wilison's](https://github.com/simonw/til) and is <del>basically a rip off</del> completely inspired by him.

Now, I'm not a front end guy, and while I can do some pretty basic stuff with GitHub Actions, I knew that what I wanted to do far outstripped my current capabilities. Enter Claude!

I started with this prompt

> You are an expert in GitHub Actions, and GitHub. Additionally, you are an expert in HTML, CSS, and JavaScript. The solutions provided can not leverage JavaScript frameworks.

I then made this request

> I currently have a Today I learned (TIL) repository on GitHub located here
> 
> https://github.com/ryancheley/til
> 
> I came across the idea of documenting cursed information here
> 
> https://immich.app/cursed-knowledge/
> 
> I would like to implement my TIL in a timeline the same way the cursed knowledge page was done. 
> 
> How can I do that?

It output this

```yaml
name: Build TIL Timeline

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
  schedule:
    # Rebuild daily at 6 AM UTC
    - cron: '0 6 * * *'

permissions:
  contents: read
  pages: write
  id-token: write

jobs:
  build-timeline:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout repository
      uses: actions/checkout@v4
      
    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '18'
        
    - name: Generate timeline data
      run: |
        node << 'EOF'
        const fs = require('fs');
        const path = require('path');
        
        // Function to extract metadata from markdown files
        function extractTilData(filePath, content) {
          const relativePath = path.relative('.', filePath);
          const fileName = path.basename(filePath, '.md');
          
          // Extract title from first heading or use filename
          const titleMatch = content.match(/^#\s+(.+)$/m);
          const title = titleMatch ? titleMatch[1] : fileName.replace(/[-_]/g, ' ');
          
          // Extract first paragraph as description
          const lines = content.split('\n').filter(line => line.trim());
          let description = '';
          for (const line of lines) {
            if (!line.startsWith('#') && line.trim() && !line.startsWith('```')) {
              description = line.trim();
              break;
            }
          }
          
          // Get file stats for date
          const stats = fs.statSync(filePath);
          const date = stats.mtime; // Use modification time
          
          // Extract category from directory structure
          const pathParts = relativePath.split('/');
          const category = pathParts.length > 1 ? pathParts[0] : 'General';
          
          return {
            title,
            description: description || 'No description available',
            date: date.toISOString().split('T')[0], // YYYY-MM-DD format
            url: `https://github.com/ryancheley/til/blob/main/${relativePath}`,
            category,
            fileName: relativePath
          };
        }
        
        // Recursively find all markdown files
        function findMarkdownFiles(dir) {
          const files = [];
          const entries = fs.readdirSync(dir, { withFileTypes: true });
          
          for (const entry of entries) {
            const fullPath = path.join(dir, entry.name);
            if (entry.isDirectory() && !entry.name.startsWith('.')) {
              files.push(...findMarkdownFiles(fullPath));
            } else if (entry.isFile() && entry.name.endsWith('.md') && entry.name !== 'README.md') {
              files.push(fullPath);
            }
          }
          
          return files;
        }
        
        // Generate timeline data
        const markdownFiles = findMarkdownFiles('.');
        const tilEntries = [];
        
        for (const filePath of markdownFiles) {
          try {
            const content = fs.readFileSync(filePath, 'utf8');
            const tilData = extractTilData(filePath, content);
            tilEntries.push(tilData);
          } catch (error) {
            console.error(`Error processing ${filePath}:`, error.message);
          }
        }
        
        // Sort by date (newest first)
        tilEntries.sort((a, b) => new Date(b.date) - new Date(a.date));
        
        // Create output directory
        if (!fs.existsSync('docs')) {
          fs.mkdirSync('docs');
        }
        
        // Write timeline data
        fs.writeFileSync('docs/timeline-data.json', JSON.stringify(tilEntries, null, 2));
        
        console.log(`Generated timeline with ${tilEntries.length} entries`);
        EOF
        
    - name: Generate timeline HTML
      run: |
        mkdir -p docs
        cat > docs/index.html << 'EOF'
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Ryan's Today I Learned Timeline</title>
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }
                
                body {
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif;
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    min-height: 100vh;
                    color: #333;
                }
                
                .container {
                    max-width: 1200px;
                    margin: 0 auto;
                    padding: 2rem;
                }
                
                .header {
                    text-align: center;
                    margin-bottom: 3rem;
                    color: white;
                }
                
                .header h1 {
                    font-size: 3rem;
                    margin-bottom: 1rem;
                    text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
                }
                
                .header p {
                    font-size: 1.2rem;
                    opacity: 0.9;
                    max-width: 600px;
                    margin: 0 auto;
                }
                
                .timeline {
                    position: relative;
                    margin-top: 2rem;
                }
                
                .timeline::before {
                    content: '';
                    position: absolute;
                    left: 2rem;
                    top: 0;
                    bottom: 0;
                    width: 2px;
                    background: linear-gradient(to bottom, #4CAF50, #2196F3, #FF9800, #E91E63);
                }
                
                .timeline-item {
                    position: relative;
                    margin-bottom: 2rem;
                    margin-left: 4rem;
                    background: white;
                    border-radius: 12px;
                    padding: 1.5rem;
                    box-shadow: 0 8px 25px rgba(0,0,0,0.1);
                    transition: transform 0.3s ease, box-shadow 0.3s ease;
                }
                
                .timeline-item:hover {
                    transform: translateY(-5px);
                    box-shadow: 0 15px 35px rgba(0,0,0,0.15);
                }
                
                .timeline-item::before {
                    content: '';
                    position: absolute;
                    left: -3rem;
                    top: 2rem;
                    width: 16px;
                    height: 16px;
                    background: #4CAF50;
                    border: 3px solid white;
                    border-radius: 50%;
                    box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.3);
                }
                
                .timeline-item:nth-child(4n+2)::before { background: #2196F3; box-shadow: 0 0 0 3px rgba(33, 150, 243, 0.3); }
                .timeline-item:nth-child(4n+3)::before { background: #FF9800; box-shadow: 0 0 0 3px rgba(255, 152, 0, 0.3); }
                .timeline-item:nth-child(4n+4)::before { background: #E91E63; box-shadow: 0 0 0 3px rgba(233, 30, 99, 0.3); }
                
                .timeline-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: flex-start;
                    margin-bottom: 1rem;
                    flex-wrap: wrap;
                    gap: 1rem;
                }
                
                .timeline-title {
                    font-size: 1.4rem;
                    font-weight: 600;
                    color: #2c3e50;
                    text-decoration: none;
                    flex-grow: 1;
                    transition: color 0.3s ease;
                }
                
                .timeline-title:hover {
                    color: #3498db;
                }
                
                .timeline-meta {
                    display: flex;
                    gap: 1rem;
                    align-items: center;
                    flex-shrink: 0;
                }
                
                .timeline-date {
                    background: linear-gradient(135deg, #667eea, #764ba2);
                    color: white;
                    padding: 0.5rem 1rem;
                    border-radius: 20px;
                    font-size: 0.9rem;
                    font-weight: 500;
                }
                
                .timeline-category {
                    background: #f8f9fa;
                    color: #6c757d;
                    padding: 0.4rem 0.8rem;
                    border-radius: 15px;
                    font-size: 0.8rem;
                    font-weight: 500;
                    border: 1px solid #e9ecef;
                }
                
                .timeline-description {
                    color: #5a6c7d;
                    line-height: 1.6;
                    font-size: 1rem;
                }
                
                .loading {
                    text-align: center;
                    padding: 3rem;
                    color: white;
                    font-size: 1.2rem;
                }
                
                .error {
                    background: #f8d7da;
                    color: #721c24;
                    padding: 1rem;
                    border-radius: 8px;
                    border: 1px solid #f5c6cb;
                    margin-bottom: 2rem;
                }
                
                .stats {
                    background: rgba(255,255,255,0.95);
                    border-radius: 12px;
                    padding: 1.5rem;
                    margin-bottom: 2rem;
                    backdrop-filter: blur(10px);
                    border: 1px solid rgba(255,255,255,0.2);
                }
                
                .stats-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                    gap: 1rem;
                    text-align: center;
                }
                
                .stat-item {
                    padding: 1rem;
                }
                
                .stat-number {
                    font-size: 2rem;
                    font-weight: bold;
                    color: #667eea;
                    display: block;
                }
                
                .stat-label {
                    color: #666;
                    font-size: 0.9rem;
                    margin-top: 0.5rem;
                }
                
                @media (max-width: 768px) {
                    .container {
                        padding: 1rem;
                    }
                    
                    .header h1 {
                        font-size: 2rem;
                    }
                    
                    .timeline::before {
                        left: 1rem;
                    }
                    
                    .timeline-item {
                        margin-left: 2rem;
                        padding: 1rem;
                    }
                    
                    .timeline-item::before {
                        left: -2rem;
                    }
                    
                    .timeline-header {
                        flex-direction: column;
                        align-items: stretch;
                    }
                    
                    .timeline-meta {
                        justify-content: space-between;
                    }
                }
            </style>
        </head>
        <body>
            <div class="container">
                <div class="header">
                    <h1>Today I Learned</h1>
                    <p>A timeline of discoveries, learnings, and insights from my development journey</p>
                </div>
                
                <div class="stats" id="stats" style="display: none;">
                    <div class="stats-grid">
                        <div class="stat-item">
                            <span class="stat-number" id="totalEntries">0</span>
                            <div class="stat-label">Total Entries</div>
                        </div>
                        <div class="stat-item">
                            <span class="stat-number" id="categoriesCount">0</span>
                            <div class="stat-label">Categories</div>
                        </div>
                        <div class="stat-item">
                            <span class="stat-number" id="latestEntry">-</span>
                            <div class="stat-label">Latest Entry</div>
                        </div>
                    </div>
                </div>
                
                <div class="loading" id="loading">Loading timeline...</div>
                <div class="error" id="error" style="display: none;"></div>
                <div class="timeline" id="timeline"></div>
            </div>
        
            <script>
                async function loadTimeline() {
                    try {
                        const response = await fetch('timeline-data.json');
                        if (!response.ok) {
                            throw new Error('Failed to load timeline data');
                        }
                        
                        const entries = await response.json();
                        displayTimeline(entries);
                        displayStats(entries);
                        
                    } catch (error) {
                        console.error('Error loading timeline:', error);
                        document.getElementById('loading').style.display = 'none';
                        document.getElementById('error').style.display = 'block';
                        document.getElementById('error').textContent = 'Failed to load timeline. Please try again later.';
                    }
                }
                
                function displayStats(entries) {
                    const categories = [...new Set(entries.map(entry => entry.category))];
                    const latest = entries.length > 0 ? new Date(entries[0].date).toLocaleDateString() : '-';
                    
                    document.getElementById('totalEntries').textContent = entries.length;
                    document.getElementById('categoriesCount').textContent = categories.length;
                    document.getElementById('latestEntry').textContent = latest;
                    document.getElementById('stats').style.display = 'block';
                }
                
                function displayTimeline(entries) {
                    const timelineContainer = document.getElementById('timeline');
                    const loading = document.getElementById('loading');
                    
                    loading.style.display = 'none';
                    
                    if (entries.length === 0) {
                        timelineContainer.innerHTML = '<p style="text-align: center; color: white;">No entries found.</p>';
                        return;
                    }
                    
                    const timelineHTML = entries.map(entry => {
                        const date = new Date(entry.date).toLocaleDateString('en-US', {
                            year: 'numeric',
                            month: 'short',
                            day: 'numeric'
                        });
                        
                        return `
                            <div class="timeline-item">
                                <div class="timeline-header">
                                    <a href="${entry.url}" class="timeline-title" target="_blank" rel="noopener noreferrer">
                                        ${entry.title}
                                    </a>
                                    <div class="timeline-meta">
                                        <span class="timeline-category">${entry.category}</span>
                                        <span class="timeline-date">${date}</span>
                                    </div>
                                </div>
                                <div class="timeline-description">
                                    ${entry.description}
                                </div>
                            </div>
                        `;
                    }).join('');
                    
                    timelineContainer.innerHTML = timelineHTML;
                }
                
                // Load timeline on page load
                loadTimeline();
            </script>
        </body>
        </html>
        EOF
        
    - name: Setup Pages
      uses: actions/configure-pages@v4
      
    - name: Upload artifact
      uses: actions/upload-pages-artifact@v3
      with:
        path: 'docs'
        
  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build-timeline
    if: github.ref == 'refs/heads/main'
    
    steps:
    - name: Deploy to GitHub Pages
      id: deployment
      uses: actions/deploy-pages@v4
```

I added it to my TIL repo and tested to see how it looked. It was a great start! 

I then followed up with

> this is a great start! however, it looks like the are a few issues:
> 1. All of the dates on the timeline are the published date and not the date of the actual learning. There is a SQLite database that stores this kind of meta data
> 2. The order of the items matches the order they are displayed on the Read Me, which is by category and not by date (see point 1)
> 3. the colors for each TIL seem to just rotate in order and aren't associated with any specific category of TIL

Claude went to work and generated a new GitHub Action for me

```yaml
name: Build TIL Timeline

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
  schedule:
    # Rebuild daily at 6 AM UTC
    - cron: '0 6 * * *'

permissions:
  contents: read
  pages: write
  id-token: write

jobs:
  build-timeline:
    runs-on: ubuntu-latest
    
    steps:
    - name: Check out repo
      uses: actions/checkout@v4
      with:
        fetch-depth: 0  # Need full history for git analysis
        
    - name: Set up Python
      uses: actions/setup-python@v5
      with:
        python-version: 3.12
        
    - uses: actions/cache@v4
      name: Configure pip caching
      with:
        path: ~/.cache/pip
        key: ${{ runner.os }}-pip-${{ hashFiles('**/requirements.txt') }}
        restore-keys: |
          ${{ runner.os }}-pip-
          
    - name: Install Python dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -r requirements.txt
        
    - name: Build database
      run: python build_database.py
      
    - name: Generate timeline data from SQLite
      run: |
        python << 'EOF'
        import sqlite3
        import json
        import os
        from pathlib import Path
        
        # Connect to the SQLite database
        db_path = Path("tils.db")
        if not db_path.exists():
            print("Database not found!")
            exit(1)
            
        conn = sqlite3.connect(db_path)
        conn.row_factory = sqlite3.Row  # Enable dict-like access to rows
        
        # Query all TIL entries, ordered by created date (actual learning date)
        cursor = conn.execute("""
            SELECT 
                path,
                slug, 
                topic,
                title,
                url,
                body,
                created,
                created_utc,
                updated,
                updated_utc
            FROM til 
            ORDER BY created_utc DESC
        """)
        
        entries = []
        for row in cursor:
            # Extract first paragraph as description, excluding headers and code blocks
            lines = row['body'].split('\n')
            description = ''
            for line in lines:
                line = line.strip()
                if line and not line.startswith('#') and not line.startswith('```') and line != '---':
                    description = line
                    break
            
            # Clean up the description
            if len(description) > 200:
                description = description[:200] + '...'
            
            # Extract date from created_utc (YYYY-MM-DD format)
            created_date = row['created_utc'].split('T')[0] if row['created_utc'] else row['created'].split('T')[0]
            
            entry = {
                'title': row['title'],
                'description': description or 'No description available',
                'date': created_date,
                'url': row['url'],
                'category': row['topic'],
                'fileName': row['path'].replace('_', '/'),  # Convert back from slug format
                'slug': row['slug']
            }
            entries.append(entry)
        
        conn.close()
        
        # Create output directory
        os.makedirs('docs', exist_ok=True)
        
        # Write timeline data
        with open('docs/timeline-data.json', 'w') as f:
            json.dump(entries, f, indent=2)
        
        print(f"Generated timeline with {len(entries)} entries")
        
        # Generate category statistics for consistent coloring
        categories = {}
        for entry in entries:
            cat = entry['category']
            if cat not in categories:
                categories[cat] = len([e for e in entries if e['category'] == cat])
        
        # Sort categories by count (most popular first) for consistent color assignment
        sorted_categories = sorted(categories.items(), key=lambda x: x[1], reverse=True)
        category_colors = {}
        
        # Define a set of distinct colors for categories
        color_palette = [
            '#4CAF50',  # Green
            '#2196F3',  # Blue  
            '#FF9800',  # Orange
            '#E91E63',  # Pink
            '#9C27B0',  # Purple
            '#00BCD4',  # Cyan
            '#FF5722',  # Deep Orange
            '#795548',  # Brown
            '#607D8B',  # Blue Grey
            '#FFC107',  # Amber
            '#8BC34A',  # Light Green
            '#3F51B5',  # Indigo
            '#F44336',  # Red
            '#009688',  # Teal
            '#CDDC39',  # Lime
        ]
        
        for i, (category, count) in enumerate(sorted_categories):
            category_colors[category] = color_palette[i % len(color_palette)]
        
        # Write category color mapping
        with open('docs/category-colors.json', 'w') as f:
            json.dump(category_colors, f, indent=2)
        
        print(f"Generated color mapping for {len(category_colors)} categories")
        EOF
        
    - name: Generate timeline HTML
      run: |
        cat > docs/index.html << 'EOF'
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Ryan's Today I Learned Timeline</title>
            <meta name="description" content="A chronological timeline of learning discoveries from software development, featuring insights on Python, Django, SQL, and more.">
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }
                
                body {
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif;
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    min-height: 100vh;
                    color: #333;
                }
                
                .container {
                    max-width: 1200px;
                    margin: 0 auto;
                    padding: 2rem;
                }
                
                .header {
                    text-align: center;
                    margin-bottom: 3rem;
                    color: white;
                }
                
                .header h1 {
                    font-size: 3rem;
                    margin-bottom: 1rem;
                    text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
                }
                
                .header p {
                    font-size: 1.2rem;
                    opacity: 0.9;
                    max-width: 600px;
                    margin: 0 auto;
                }
                
                .filters {
                    background: rgba(255,255,255,0.95);
                    border-radius: 12px;
                    padding: 1.5rem;
                    margin-bottom: 2rem;
                    backdrop-filter: blur(10px);
                    border: 1px solid rgba(255,255,255,0.2);
                }
                
                .filter-group {
                    display: flex;
                    flex-wrap: wrap;
                    gap: 0.5rem;
                    align-items: center;
                }
                
                .filter-label {
                    font-weight: 600;
                    margin-right: 1rem;
                    color: #666;
                }
                
                .category-filter {
                    padding: 0.4rem 0.8rem;
                    border-radius: 20px;
                    border: 2px solid transparent;
                    background: #f8f9fa;
                    color: #666;
                    cursor: pointer;
                    transition: all 0.3s ease;
                    font-size: 0.9rem;
                    user-select: none;
                }
                
                .category-filter:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 4px 8px rgba(0,0,0,0.1);
                }
                
                .category-filter.active {
                    color: white;
                    border-color: currentColor;
                    font-weight: 600;
                }
                
                .timeline {
                    position: relative;
                    margin-top: 2rem;
                }
                
                .timeline::before {
                    content: '';
                    position: absolute;
                    left: 2rem;
                    top: 0;
                    bottom: 0;
                    width: 2px;
                    background: linear-gradient(to bottom, #4CAF50, #2196F3, #FF9800, #E91E63);
                }
                
                .timeline-item {
                    position: relative;
                    margin-bottom: 2rem;
                    margin-left: 4rem;
                    background: white;
                    border-radius: 12px;
                    padding: 1.5rem;
                    box-shadow: 0 8px 25px rgba(0,0,0,0.1);
                    transition: all 0.3s ease;
                    opacity: 1;
                }
                
                .timeline-item.hidden {
                    display: none;
                }
                
                .timeline-item:hover {
                    transform: translateY(-5px);
                    box-shadow: 0 15px 35px rgba(0,0,0,0.15);
                }
                
                .timeline-item::before {
                    content: '';
                    position: absolute;
                    left: -3rem;
                    top: 2rem;
                    width: 16px;
                    height: 16px;
                    background: var(--category-color, #4CAF50);
                    border: 3px solid white;
                    border-radius: 50%;
                    box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.3);
                }
                
                .timeline-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: flex-start;
                    margin-bottom: 1rem;
                    flex-wrap: wrap;
                    gap: 1rem;
                }
                
                .timeline-title {
                    font-size: 1.4rem;
                    font-weight: 600;
                    color: #2c3e50;
                    text-decoration: none;
                    flex-grow: 1;
                    transition: color 0.3s ease;
                }
                
                .timeline-title:hover {
                    color: #3498db;
                }
                
                .timeline-meta {
                    display: flex;
                    gap: 1rem;
                    align-items: center;
                    flex-shrink: 0;
                }
                
                .timeline-date {
                    background: linear-gradient(135deg, #667eea, #764ba2);
                    color: white;
                    padding: 0.5rem 1rem;
                    border-radius: 20px;
                    font-size: 0.9rem;
                    font-weight: 500;
                }
                
                .timeline-category {
                    background: var(--category-color, #f8f9fa);
                    color: white;
                    padding: 0.4rem 0.8rem;
                    border-radius: 15px;
                    font-size: 0.8rem;
                    font-weight: 500;
                    border: 1px solid rgba(255,255,255,0.2);
                }
                
                .timeline-description {
                    color: #5a6c7d;
                    line-height: 1.6;
                    font-size: 1rem;
                }
                
                .loading {
                    text-align: center;
                    padding: 3rem;
                    color: white;
                    font-size: 1.2rem;
                }
                
                .error {
                    background: #f8d7da;
                    color: #721c24;
                    padding: 1rem;
                    border-radius: 8px;
                    border: 1px solid #f5c6cb;
                    margin-bottom: 2rem;
                }
                
                .stats {
                    background: rgba(255,255,255,0.95);
                    border-radius: 12px;
                    padding: 1.5rem;
                    margin-bottom: 2rem;
                    backdrop-filter: blur(10px);
                    border: 1px solid rgba(255,255,255,0.2);
                }
                
                .stats-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                    gap: 1rem;
                    text-align: center;
                }
                
                .stat-item {
                    padding: 1rem;
                }
                
                .stat-number {
                    font-size: 2rem;
                    font-weight: bold;
                    color: #667eea;
                    display: block;
                }
                
                .stat-label {
                    color: #666;
                    font-size: 0.9rem;
                    margin-top: 0.5rem;
                }
                
                @media (max-width: 768px) {
                    .container {
                        padding: 1rem;
                    }
                    
                    .header h1 {
                        font-size: 2rem;
                    }
                    
                    .timeline::before {
                        left: 1rem;
                    }
                    
                    .timeline-item {
                        margin-left: 2rem;
                        padding: 1rem;
                    }
                    
                    .timeline-item::before {
                        left: -2rem;
                    }
                    
                    .timeline-header {
                        flex-direction: column;
                        align-items: stretch;
                    }
                    
                    .timeline-meta {
                        justify-content: space-between;
                    }
                    
                    .filter-group {
                        flex-direction: column;
                        align-items: stretch;
                        gap: 1rem;
                    }
                    
                    .category-filter {
                        text-align: center;
                    }
                }
            </style>
        </head>
        <body>
            <div class="container">
                <div class="header">
                    <h1>Today I Learned</h1>
                    <p>A chronological timeline of discoveries, learnings, and insights from my development journey</p>
                </div>
                
                <div class="stats" id="stats" style="display: none;">
                    <div class="stats-grid">
                        <div class="stat-item">
                            <span class="stat-number" id="totalEntries">0</span>
                            <div class="stat-label">Total Entries</div>
                        </div>
                        <div class="stat-item">
                            <span class="stat-number" id="categoriesCount">0</span>
                            <div class="stat-label">Categories</div>
                        </div>
                        <div class="stat-item">
                            <span class="stat-number" id="latestEntry">-</span>
                            <div class="stat-label">Latest Entry</div>
                        </div>
                        <div class="stat-item">
                            <span class="stat-number" id="filteredCount">0</span>
                            <div class="stat-label">Showing</div>
                        </div>
                    </div>
                </div>
                
                <div class="filters" id="filters" style="display: none;">
                    <div class="filter-group">
                        <span class="filter-label">Filter by category:</span>
                        <div id="categoryFilters"></div>
                    </div>
                </div>
                
                <div class="loading" id="loading">Loading timeline...</div>
                <div class="error" id="error" style="display: none;"></div>
                <div class="timeline" id="timeline"></div>
            </div>
        
            <script>
                let allEntries = [];
                let categoryColors = {};
                let activeCategory = null;
                
                async function loadTimeline() {
                    try {
                        // Load timeline data and category colors
                        const [entriesResponse, colorsResponse] = await Promise.all([
                            fetch('timeline-data.json'),
                            fetch('category-colors.json')
                        ]);
                        
                        if (!entriesResponse.ok || !colorsResponse.ok) {
                            throw new Error('Failed to load timeline data');
                        }
                        
                        allEntries = await entriesResponse.json();
                        categoryColors = await colorsResponse.json();
                        
                        displayTimeline(allEntries);
                        displayStats(allEntries);
                        createCategoryFilters();
                        
                    } catch (error) {
                        console.error('Error loading timeline:', error);
                        document.getElementById('loading').style.display = 'none';
                        document.getElementById('error').style.display = 'block';
                        document.getElementById('error').textContent = 'Failed to load timeline. Please try again later.';
                    }
                }
                
                function createCategoryFilters() {
                    const categories = [...new Set(allEntries.map(entry => entry.category))];
                    const filtersContainer = document.getElementById('categoryFilters');
                    
                    // Add "All" filter
                    const allFilter = document.createElement('span');
                    allFilter.className = 'category-filter active';
                    allFilter.textContent = 'All';
                    allFilter.onclick = () => filterByCategory(null);
                    filtersContainer.appendChild(allFilter);
                    
                    // Add category filters
                    categories.sort().forEach(category => {
                        const filter = document.createElement('span');
                        filter.className = 'category-filter';
                        filter.textContent = category;
                        filter.style.setProperty('--category-color', categoryColors[category] || '#666');
                        filter.onclick = () => filterByCategory(category);
                        filtersContainer.appendChild(filter);
                    });
                    
                    document.getElementById('filters').style.display = 'block';
                }
                
                function filterByCategory(category) {
                    activeCategory = category;
                    
                    // Update filter button states
                    document.querySelectorAll('.category-filter').forEach(filter => {
                        filter.classList.remove('active');
                        if ((category === null && filter.textContent === 'All') || 
                            filter.textContent === category) {
                            filter.classList.add('active');
                            if (category !== null) {
                                filter.style.background = categoryColors[category];
                            }
                        }
                    });
                    
                    // Filter timeline items
                    const filteredEntries = category ? 
                        allEntries.filter(entry => entry.category === category) : 
                        allEntries;
                    
                    displayTimeline(filteredEntries);
                    updateFilteredCount(filteredEntries.length);
                }
                
                function updateFilteredCount(count) {
                    document.getElementById('filteredCount').textContent = count;
                }
                
                function displayStats(entries) {
                    const categories = [...new Set(entries.map(entry => entry.category))];
                    const latest = entries.length > 0 ? new Date(entries[0].date).toLocaleDateString() : '-';
                    
                    document.getElementById('totalEntries').textContent = entries.length;
                    document.getElementById('categoriesCount').textContent = categories.length;
                    document.getElementById('latestEntry').textContent = latest;
                    document.getElementById('filteredCount').textContent = entries.length;
                    document.getElementById('stats').style.display = 'block';
                }
                
                function displayTimeline(entries) {
                    const timelineContainer = document.getElementById('timeline');
                    const loading = document.getElementById('loading');
                    
                    loading.style.display = 'none';
                    
                    if (entries.length === 0) {
                        timelineContainer.innerHTML = '<p style="text-align: center; color: white;">No entries found.</p>';
                        return;
                    }
                    
                    const timelineHTML = entries.map(entry => {
                        const date = new Date(entry.date).toLocaleDateString('en-US', {
                            year: 'numeric',
                            month: 'short',
                            day: 'numeric'
                        });
                        
                        const categoryColor = categoryColors[entry.category] || '#666';
                        
                        return `
                            <div class="timeline-item" style="--category-color: ${categoryColor}">
                                <div class="timeline-header">
                                    <a href="${entry.url}" class="timeline-title" target="_blank" rel="noopener noreferrer">
                                        ${entry.title}
                                    </a>
                                    <div class="timeline-meta">
                                        <span class="timeline-category" style="--category-color: ${categoryColor}; background: ${categoryColor};">
                                            ${entry.category}
                                        </span>
                                        <span class="timeline-date">${date}</span>
                                    </div>
                                </div>
                                <div class="timeline-description">
                                    ${entry.description}
                                </div>
                            </div>
                        `;
                    }).join('');
                    
                    timelineContainer.innerHTML = timelineHTML;
                }
                
                // Load timeline on page load
                loadTimeline();
            </script>
        </body>
        </html>
        EOF
        
    - name: Setup Pages
      uses: actions/configure-pages@v4
      
    - name: Upload artifact
      uses: actions/upload-pages-artifact@v3
      with:
        path: 'docs'
        
  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build-timeline
    if: github.ref == 'refs/heads/main'
    
    steps:
    - name: Deploy to GitHub Pages
      id: deployment
      uses: actions/deploy-pages@v4
```

Another huge step forward! However, there was one last change that was needed

> oh wow! much better! The last issue I'm seeing is that because I have so many categories, the Filter by category needs a way to wrap based on the page width. Right now it's on a single line, but would likely benefit from a css style that will wrap the lines

And I got this

```yaml
name: Build TIL Timeline

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
  schedule:
    # Rebuild daily at 6 AM UTC
    - cron: '0 6 * * *'

permissions:
  contents: read
  pages: write
  id-token: write

jobs:
  build-timeline:
    runs-on: ubuntu-latest
    
    steps:
    - name: Check out repo
      uses: actions/checkout@v4
      with:
        fetch-depth: 0  # Need full history for git analysis
        
    - name: Set up Python
      uses: actions/setup-python@v5
      with:
        python-version: 3.12
        
    - uses: actions/cache@v4
      name: Configure pip caching
      with:
        path: ~/.cache/pip
        key: ${{ runner.os }}-pip-${{ hashFiles('**/requirements.txt') }}
        restore-keys: |
          ${{ runner.os }}-pip-
          
    - name: Install Python dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -r requirements.txt
        
    - name: Build database
      run: python build_database.py
      
    - name: Generate timeline data from SQLite
      run: |
        python << 'EOF'
        import sqlite3
        import json
        import os
        from pathlib import Path
        
        # Connect to the SQLite database
        db_path = Path("tils.db")
        if not db_path.exists():
            print("Database not found!")
            exit(1)
            
        conn = sqlite3.connect(db_path)
        conn.row_factory = sqlite3.Row  # Enable dict-like access to rows
        
        # Query all TIL entries, ordered by created date (actual learning date)
        cursor = conn.execute("""
            SELECT 
                path,
                slug, 
                topic,
                title,
                url,
                body,
                created,
                created_utc,
                updated,
                updated_utc
            FROM til 
            ORDER BY created_utc DESC
        """)
        
        entries = []
        for row in cursor:
            # Extract first paragraph as description, excluding headers and code blocks
            lines = row['body'].split('\n')
            description = ''
            for line in lines:
                line = line.strip()
                if line and not line.startswith('#') and not line.startswith('```') and line != '---':
                    description = line
                    break
            
            # Clean up the description
            if len(description) > 200:
                description = description[:200] + '...'
            
            # Extract date from created_utc (YYYY-MM-DD format)
            created_date = row['created_utc'].split('T')[0] if row['created_utc'] else row['created'].split('T')[0]
            
            entry = {
                'title': row['title'],
                'description': description or 'No description available',
                'date': created_date,
                'url': row['url'],
                'category': row['topic'],
                'fileName': row['path'].replace('_', '/'),  # Convert back from slug format
                'slug': row['slug']
            }
            entries.append(entry)
        
        conn.close()
        
        # Create output directory
        os.makedirs('docs', exist_ok=True)
        
        # Write timeline data
        with open('docs/timeline-data.json', 'w') as f:
            json.dump(entries, f, indent=2)
        
        print(f"Generated timeline with {len(entries)} entries")
        
        # Generate category statistics for consistent coloring
        categories = {}
        for entry in entries:
            cat = entry['category']
            if cat not in categories:
                categories[cat] = len([e for e in entries if e['category'] == cat])
        
        # Sort categories by count (most popular first) for consistent color assignment
        sorted_categories = sorted(categories.items(), key=lambda x: x[1], reverse=True)
        category_colors = {}
        
        # Define a set of distinct colors for categories
        color_palette = [
            '#4CAF50',  # Green
            '#2196F3',  # Blue  
            '#FF9800',  # Orange
            '#E91E63',  # Pink
            '#9C27B0',  # Purple
            '#00BCD4',  # Cyan
            '#FF5722',  # Deep Orange
            '#795548',  # Brown
            '#607D8B',  # Blue Grey
            '#FFC107',  # Amber
            '#8BC34A',  # Light Green
            '#3F51B5',  # Indigo
            '#F44336',  # Red
            '#009688',  # Teal
            '#CDDC39',  # Lime
        ]
        
        for i, (category, count) in enumerate(sorted_categories):
            category_colors[category] = color_palette[i % len(color_palette)]
        
        # Write category color mapping
        with open('docs/category-colors.json', 'w') as f:
            json.dump(category_colors, f, indent=2)
        
        print(f"Generated color mapping for {len(category_colors)} categories")
        EOF
        
    - name: Generate timeline HTML
      run: |
        cat > docs/index.html << 'EOF'
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Ryan's Today I Learned Timeline</title>
            <meta name="description" content="A chronological timeline of learning discoveries from software development, featuring insights on Python, Django, SQL, and more.">
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }
                
                body {
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif;
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    min-height: 100vh;
                    color: #333;
                }
                
                .container {
                    max-width: 1200px;
                    margin: 0 auto;
                    padding: 2rem;
                }
                
                .header {
                    text-align: center;
                    margin-bottom: 3rem;
                    color: white;
                }
                
                .header h1 {
                    font-size: 3rem;
                    margin-bottom: 1rem;
                    text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
                }
                
                .header p {
                    font-size: 1.2rem;
                    opacity: 0.9;
                    max-width: 600px;
                    margin: 0 auto;
                }
                
                .filters {
                    background: rgba(255,255,255,0.95);
                    border-radius: 12px;
                    padding: 1.5rem;
                    margin-bottom: 2rem;
                    backdrop-filter: blur(10px);
                    border: 1px solid rgba(255,255,255,0.2);
                }
                
                .filter-group {
                    display: flex;
                    flex-direction: column;
                    gap: 1rem;
                }
                
                .filter-label {
                    font-weight: 600;
                    color: #666;
                    margin-bottom: 0.5rem;
                }
                
                .category-filters-container {
                    display: flex;
                    flex-wrap: wrap;
                    gap: 0.5rem;
                    align-items: center;
                }
                
                .category-filter {
                    padding: 0.4rem 0.8rem;
                    border-radius: 20px;
                    border: 2px solid transparent;
                    background: #f8f9fa;
                    color: #666;
                    cursor: pointer;
                    transition: all 0.3s ease;
                    font-size: 0.9rem;
                    user-select: none;
                }
                
                .category-filter:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 4px 8px rgba(0,0,0,0.1);
                }
                
                .category-filter.active {
                    color: white;
                    border-color: currentColor;
                    font-weight: 600;
                }
                
                .timeline {
                    position: relative;
                    margin-top: 2rem;
                }
                
                .timeline::before {
                    content: '';
                    position: absolute;
                    left: 2rem;
                    top: 0;
                    bottom: 0;
                    width: 2px;
                    background: linear-gradient(to bottom, #4CAF50, #2196F3, #FF9800, #E91E63);
                }
                
                .timeline-item {
                    position: relative;
                    margin-bottom: 2rem;
                    margin-left: 4rem;
                    background: white;
                    border-radius: 12px;
                    padding: 1.5rem;
                    box-shadow: 0 8px 25px rgba(0,0,0,0.1);
                    transition: all 0.3s ease;
                    opacity: 1;
                }
                
                .timeline-item.hidden {
                    display: none;
                }
                
                .timeline-item:hover {
                    transform: translateY(-5px);
                    box-shadow: 0 15px 35px rgba(0,0,0,0.15);
                }
                
                .timeline-item::before {
                    content: '';
                    position: absolute;
                    left: -3rem;
                    top: 2rem;
                    width: 16px;
                    height: 16px;
                    background: var(--category-color, #4CAF50);
                    border: 3px solid white;
                    border-radius: 50%;
                    box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.3);
                }
                
                .timeline-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: flex-start;
                    margin-bottom: 1rem;
                    flex-wrap: wrap;
                    gap: 1rem;
                }
                
                .timeline-title {
                    font-size: 1.4rem;
                    font-weight: 600;
                    color: #2c3e50;
                    text-decoration: none;
                    flex-grow: 1;
                    transition: color 0.3s ease;
                }
                
                .timeline-title:hover {
                    color: #3498db;
                }
                
                .timeline-meta {
                    display: flex;
                    gap: 1rem;
                    align-items: center;
                    flex-shrink: 0;
                }
                
                .timeline-date {
                    background: linear-gradient(135deg, #667eea, #764ba2);
                    color: white;
                    padding: 0.5rem 1rem;
                    border-radius: 20px;
                    font-size: 0.9rem;
                    font-weight: 500;
                }
                
                .timeline-category {
                    background: var(--category-color, #f8f9fa);
                    color: white;
                    padding: 0.4rem 0.8rem;
                    border-radius: 15px;
                    font-size: 0.8rem;
                    font-weight: 500;
                    border: 1px solid rgba(255,255,255,0.2);
                }
                
                .timeline-description {
                    color: #5a6c7d;
                    line-height: 1.6;
                    font-size: 1rem;
                }
                
                .loading {
                    text-align: center;
                    padding: 3rem;
                    color: white;
                    font-size: 1.2rem;
                }
                
                .error {
                    background: #f8d7da;
                    color: #721c24;
                    padding: 1rem;
                    border-radius: 8px;
                    border: 1px solid #f5c6cb;
                    margin-bottom: 2rem;
                }
                
                .stats {
                    background: rgba(255,255,255,0.95);
                    border-radius: 12px;
                    padding: 1.5rem;
                    margin-bottom: 2rem;
                    backdrop-filter: blur(10px);
                    border: 1px solid rgba(255,255,255,0.2);
                }
                
                .stats-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                    gap: 1rem;
                    text-align: center;
                }
                
                .stat-item {
                    padding: 1rem;
                }
                
                .stat-number {
                    font-size: 2rem;
                    font-weight: bold;
                    color: #667eea;
                    display: block;
                }
                
                .stat-label {
                    color: #666;
                    font-size: 0.9rem;
                    margin-top: 0.5rem;
                }
                
                @media (max-width: 768px) {
                    .container {
                        padding: 1rem;
                    }
                    
                    .header h1 {
                        font-size: 2rem;
                    }
                    
                    .timeline::before {
                        left: 1rem;
                    }
                    
                    .timeline-item {
                        margin-left: 2rem;
                        padding: 1rem;
                    }
                    
                    .timeline-item::before {
                        left: -2rem;
                    }
                    
                    .timeline-header {
                        flex-direction: column;
                        align-items: stretch;
                    }
                    
                    .timeline-meta {
                        justify-content: space-between;
                    }
                    
                    .filter-group {
                        gap: 1rem;
                    }
                    
                    .category-filters-container {
                        justify-content: center;
                    }
                }
            </style>
        </head>
        <body>
            <div class="container">
                <div class="header">
                    <h1>Today I Learned</h1>
                    <p>A chronological timeline of discoveries, learnings, and insights from my development journey</p>
                </div>
                
                <div class="stats" id="stats" style="display: none;">
                    <div class="stats-grid">
                        <div class="stat-item">
                            <span class="stat-number" id="totalEntries">0</span>
                            <div class="stat-label">Total Entries</div>
                        </div>
                        <div class="stat-item">
                            <span class="stat-number" id="categoriesCount">0</span>
                            <div class="stat-label">Categories</div>
                        </div>
                        <div class="stat-item">
                            <span class="stat-number" id="latestEntry">-</span>
                            <div class="stat-label">Latest Entry</div>
                        </div>
                        <div class="stat-item">
                            <span class="stat-number" id="filteredCount">0</span>
                            <div class="stat-label">Showing</div>
                        </div>
                    </div>
                </div>
                
                <div class="filters" id="filters" style="display: none;">
                    <div class="filter-group">
                        <span class="filter-label">Filter by category:</span>
                        <div class="category-filters-container" id="categoryFilters"></div>
                    </div>
                </div>
                
                <div class="loading" id="loading">Loading timeline...</div>
                <div class="error" id="error" style="display: none;"></div>
                <div class="timeline" id="timeline"></div>
            </div>
        
            <script>
                let allEntries = [];
                let categoryColors = {};
                let activeCategory = null;
                
                async function loadTimeline() {
                    try {
                        // Load timeline data and category colors
                        const [entriesResponse, colorsResponse] = await Promise.all([
                            fetch('timeline-data.json'),
                            fetch('category-colors.json')
                        ]);
                        
                        if (!entriesResponse.ok || !colorsResponse.ok) {
                            throw new Error('Failed to load timeline data');
                        }
                        
                        allEntries = await entriesResponse.json();
                        categoryColors = await colorsResponse.json();
                        
                        displayTimeline(allEntries);
                        displayStats(allEntries);
                        createCategoryFilters();
                        
                    } catch (error) {
                        console.error('Error loading timeline:', error);
                        document.getElementById('loading').style.display = 'none';
                        document.getElementById('error').style.display = 'block';
                        document.getElementById('error').textContent = 'Failed to load timeline. Please try again later.';
                    }
                }
                
                function createCategoryFilters() {
                    const categories = [...new Set(allEntries.map(entry => entry.category))];
                    const filtersContainer = document.getElementById('categoryFilters');
                    
                    // Add "All" filter
                    const allFilter = document.createElement('span');
                    allFilter.className = 'category-filter active';
                    allFilter.textContent = 'All';
                    allFilter.onclick = () => filterByCategory(null);
                    filtersContainer.appendChild(allFilter);
                    
                    // Add category filters
                    categories.sort().forEach(category => {
                        const filter = document.createElement('span');
                        filter.className = 'category-filter';
                        filter.textContent = category;
                        filter.style.setProperty('--category-color', categoryColors[category] || '#666');
                        filter.onclick = () => filterByCategory(category);
                        filtersContainer.appendChild(filter);
                    });
                    
                    document.getElementById('filters').style.display = 'block';
                }
                
                function filterByCategory(category) {
                    activeCategory = category;
                    
                    // Update filter button states
                    document.querySelectorAll('.category-filter').forEach(filter => {
                        filter.classList.remove('active');
                        if ((category === null && filter.textContent === 'All') || 
                            filter.textContent === category) {
                            filter.classList.add('active');
                            if (category !== null) {
                                filter.style.background = categoryColors[category];
                            }
                        }
                    });
                    
                    // Filter timeline items
                    const filteredEntries = category ? 
                        allEntries.filter(entry => entry.category === category) : 
                        allEntries;
                    
                    displayTimeline(filteredEntries);
                    updateFilteredCount(filteredEntries.length);
                }
                
                function updateFilteredCount(count) {
                    document.getElementById('filteredCount').textContent = count;
                }
                
                function displayStats(entries) {
                    const categories = [...new Set(entries.map(entry => entry.category))];
                    const latest = entries.length > 0 ? new Date(entries[0].date).toLocaleDateString() : '-';
                    
                    document.getElementById('totalEntries').textContent = entries.length;
                    document.getElementById('categoriesCount').textContent = categories.length;
                    document.getElementById('latestEntry').textContent = latest;
                    document.getElementById('filteredCount').textContent = entries.length;
                    document.getElementById('stats').style.display = 'block';
                }
                
                function displayTimeline(entries) {
                    const timelineContainer = document.getElementById('timeline');
                    const loading = document.getElementById('loading');
                    
                    loading.style.display = 'none';
                    
                    if (entries.length === 0) {
                        timelineContainer.innerHTML = '<p style="text-align: center; color: white;">No entries found.</p>';
                        return;
                    }
                    
                    const timelineHTML = entries.map(entry => {
                        const date = new Date(entry.date).toLocaleDateString('en-US', {
                            year: 'numeric',
                            month: 'short',
                            day: 'numeric'
                        });
                        
                        const categoryColor = categoryColors[entry.category] || '#666';
                        
                        return `
                            <div class="timeline-item" style="--category-color: ${categoryColor}">
                                <div class="timeline-header">
                                    <a href="${entry.url}" class="timeline-title" target="_blank" rel="noopener noreferrer">
                                        ${entry.title}
                                    </a>
                                    <div class="timeline-meta">
                                        <span class="timeline-category" style="--category-color: ${categoryColor}; background: ${categoryColor};">
                                            ${entry.category}
                                        </span>
                                        <span class="timeline-date">${date}</span>
                                    </div>
                                </div>
                                <div class="timeline-description">
                                    ${entry.description}
                                </div>
                            </div>
                        `;
                    }).join('');
                    
                    timelineContainer.innerHTML = timelineHTML;
                }
                
                // Load timeline on page load
                loadTimeline();
            </script>
        </body>
        </html>
        EOF
        
    - name: Setup Pages
      uses: actions/configure-pages@v4
      
    - name: Upload artifact
      uses: actions/upload-pages-artifact@v3
      with:
        path: 'docs'
        
  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build-timeline
    if: github.ref == 'refs/heads/main'
    
    steps:
    - name: Deploy to GitHub Pages
      id: deployment
      uses: actions/deploy-pages@v4
```

All told from start to finish, this took about 20 minutes. There are still some potential updates, but for 20 minutes of work I was able to take a 'wild' idea that I would have never been able to do before and had something that I'm actually excited about! And it has the added bonus of encouraging me to write more TILs because I now have [this nice looking timeline](https://ryancheley.github.io/til/) of my TILs.