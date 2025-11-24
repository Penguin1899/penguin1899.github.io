<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>The Journey</title>
    
    <link href="./dist/output.css" rel="stylesheet" />
    <!-- Uncomment this to enable flowbite -->
    <!-- Docs - https://flowbite.com/docs/getting-started/introduction/ -->
    <!-- <link href="https://cdn.jsdelivr.net/npm/flowbite@3.1.2/dist/flowbite.min.css" rel="stylesheet" /> -->

  </head>

  <body class="text-gray-800 font-sans scroll-smooth">
    <!-- Navbar -->
    <header class="fixed top-0 w-full bg-white shadow z-50">
      <nav class="container mx-auto px-4 py-4 flex justify-between items-center">
        <h1 class="text-xl font-bold">${personal['name']}</h1>
        <ul class="flex space-x-6 text-sm font-medium">
          <li><a href="#about" class="scroll-smooth hover:text-blue-500">About</a></li>
          <li><a href="#skills" class="scroll-smooth hover:text-blue-500">Skills</a></li>
          <li><a href="#experience" class="scroll-smooth hover:text-blue-500">Experience</a></li>
          <li><a href="#projects" class="scroll-smooth hover:text-blue-500">Projects</a></li>
          <li><a href="#contact" class="scroll-smooth hover:text-blue-500">Contact</a></li>
        </ul>
      </nav>
    </header>

    <!-- Hero Section (boast about yourself)-->
    <section id="hero" class="bg-gradient-to-b from-blue-100 via-white to-blue-100 h-screen flex items-center justify-center">
      <div class="text-center px-4">
        <h2 class="text-4xl md:text-6xl font-bold mb-4">${personal['title']}</h2>
        <h3 class="text-4xl md:text-3xl font-bold mb-4">${personal['subtitle']}</h3>
        <p class="text-lg md:text-xl mb-6 text-gray-600">${personal['description']}</p>
        <a href="#projects" class="inline-block px-6 py-3 bg-blue-600 text-white rounded-full hover:bg-blue-700 transition">
          View My Work
        </a>
      </div>
    </section>

    <!-- About Me Section -->
    <section id="about" class="bg-gradient-to-b from-blue-100 via-white to-blue-100 h-screen flex items-center justify-center">  
        <!-- bg-gray-100 py-20 px-6 -->
        <div class="max-w-3xl text-center">
        <h2 class="text-4xl font-bold mb-6 text-gray-800">About Me</h2>
        <p class="text-lg text-gray-600 leading-relaxed">
            ${personal['about_me']}
        </p>
        <p class="mt-4 text-gray-500 text-sm">
            ${personal['about_note']}
        </p>
        </div>
    </section>

    <!-- Skills section -->
    <section id="skills" class="bg-gradient-to-b from-blue-100 via-white to-blue-100 min-h-screen flex py-20 px-4">
        <div class="max-w-6xl mx-auto">
            <h2 class="text-5xl font-bold text-center text-gray-800 mb-16">Tech Stack</h2>
        
            % for category in skills['categories']:
            <!-- ${category['name']} -->
            <div class="mb-20 rounded-xl border border-gray-300 p-6 shadow-lg">
                <h3 class="text-3xl text-center text-gray-800 mb-10">${category['name']}</h3>
                <div class="flex flex-wrap justify-center gap-10">
                    % for item in category['items']:
                    <div class="flex flex-col items-center w-24">
                        <img src="${item['icon']}" class="w-12 h-12" />
                        <span class="mt-2 text-sm font-medium text-gray-700 text-center">${item['name']}</span>
                    </div>
                    % endfor
                </div>
            </div>
            % endfor
        </div>
    </section>
  
    <!-- Experience Section -->
    <section id="experience" class="bg-gradient-to-b from-blue-100 via-white to-blue-100 py-20 px-4">
        <div class="max-w-4xl mx-auto">
            <h2 class="text-5xl font-bold text-center text-gray-800 mb-16">Experience</h2>
                
            <!-- Timeline Container -->
            <div class="relative border-l-3 border-gray-600 ml-6">
                % for job in experience['jobs']:
                <!-- Timeline Item -->
                <div class="mb-10 ml-5">
                    <!-- add a round mark to show current state -->
                    <div class="absolute w-4 h-4 bg-blue-600 rounded-full -left-2.5 top-1.5"></div>
                    
                    <h3 class="text-xl font-semibold text-gray-800">${job['title']}</h3>
                    <span class="text-sm text-gray-500">${job['period']}</span>
                    <ol class="mt-4 text-gray-600 list-disc list-inside space-y-1">
                        % for responsibility in job['responsibilities']:
                        <li>${responsibility}</li>
                        % endfor
                    </ol>
                </div>
                % endfor
            <!-- Add more items as needed -->
          </div>
        </div>
    </section>

    <!-- Projects Section -->
    <section id="projects" class="bg-gradient-to-b from-blue-100 via-white to-blue-100 py-20 px-4">
        <div class="max-w-6xl mx-auto">
          <h2 class="text-5xl font-bold text-center text-gray-800 mb-16">Projects</h2>
      
          % for company in projects['companies']:
          <!-- Company Group -->
          <div class="mb-16">
                <h3 class="text-3xl font-semibold text-center text-gray-800 mb-6">${company['name']}</h3>
        
                <div class="grid md:grid-cols-2 gap-8">
                    % for project in company['projects']:
                    <!-- Project Card -->
                    <div class="bg-white rounded-xl shadow-lg p-6 border border-gray-200">
                        <h4 class="text-xl font-bold text-gray-800 mb-2">${project['title']}</h4>
                        <span class="text-sm text-gray-500 mb-4 block">${project['period']}</span>
                        % if '\n' in project['description']:
                            % for paragraph in project['description'].split('\n'):
                                % if paragraph.strip():
                                    <p class="text-gray-600 mb-4">${paragraph.strip()}</p>
                                % endif
                            % endfor
                        % else:
                            <p class="text-gray-600 mb-4">${project['description']}</p>
                        % endif
                        <div class="flex flex-wrap gap-3 text-sm mb-4">
                            % for tech in project['technologies']:
                            <span class="${tech['color']} px-2 py-1 rounded">${tech['name']}</span>
                            % endfor
                        </div>
                        % if 'links' in project:
                        <div class="flex space-x-4">
                            % for link in project['links']:
                            <a href="${link['url']}" class="text-blue-600 hover:underline text-sm">${link['name']}</a>
                            % endfor
                        </div>
                        % endif
                    </div>
                    % endfor
                </div>
          </div>
          % endfor
        </div>
    </section>

    <!-- Contact Section -->
    <section id="contact" class="py-16 bg-gradient-to-b from-blue-100 via-white to-blue-100 h-screen flex items-center justify-center">
        <div class="w-full max-w-lg px-4">
          
          <h2 class="text-3xl font-bold mb-6 text-gray-800 dark:text-teal text-center">My Socials</h2>
          
          <!-- Social Media Links -->
          <div class="flex justify-center space-x-4 mb-12">
            % for social in contact['social_links']:
            <a href="${social['url']}" target="${social['target']}" rel="noopener noreferrer" class="${social['button_class']} text-white font-bold py-4 px-9 rounded-full focus:outline-none focus:shadow-outline">
              ${social['name']}
            </a>
            % endfor
          </div>
          
          <!-- Send Email Section -->
          <!-- <h2 class="text-3xl font-bold mb-6 text-gray-800 dark:text-teal text-center">Send me an Email!</h2>
          
          <form class="w-full">
            <div class="mb-6">
              <input class="appearance-none bg-transparent border-b-2 border-teal-500 w-full text-gray-400 py-3 px-5 leading-tight focus:outline-none dark:text-teal" type="text" placeholder="Your Name" aria-label="Name" required>
            </div>
            
            <div class="mb-10">
              <input class="appearance-none bg-transparent border-b-2 border-teal-500 w-full text-gray-400 py-3 px-5 leading-tight focus:outline-none dark:text-teal" type="email" placeholder="you@example.com" aria-label="Email" required>
            </div>
            
            <div class="mb-6">
              <textarea class="appearance-none bg-transparent border-2 border-teal-500 rounded-xl w-full text-gray-400 py-3 px-5 leading-tight focus:outline-none resize-none dark:text-teal" rows="5" placeholder="Your message..." aria-label="Message" required></textarea>
            </div>
            
            <div class="flex items-center justify-center">
              <button class="bg-teal-500 hover:bg-teal-700 text-white font-bold py-2.5 px-6 rounded focus:outline-none focus:shadow-outline" type="submit">
                Send Message
              </button>
            </div>
          </form> -->

        </div>
      </section>
      
      
            
    <!-- Uncomment this to enable flowbite -->
    <!-- <script src="https://cdn.jsdelivr.net/npm/flowbite@3.1.2/dist/flowbite.min.js"></script> -->
    </body>

  <footer class="text-center text-sm text-gray-500 py-6">
    ${contact['footer_text'] | n}
  </footer>

</html>
