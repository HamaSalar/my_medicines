<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Medicine - Your Health In Your Hands</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Lucide Icons -->
    <script src="https://unpkg.com/lucide@latest"></script> 
    <!-- AOS Animation Library -->
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <!-- Parallax.js -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/parallax.js/1.5.0/parallax.min.js"></script>
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="bg-gray-50 font-sans">
    <?php
    // Define variables
    $appName = "My Medicine";
    $navItems = [
        "Home" => "#",
        "Benefits" => "#benefits",
        "Gallery" => "#gallery",
        "Download" => "#download"
    ];
    $benefits = [
        [
            "icon" => "thumbs-up",
            "title" => "Improved Adherence",
            "description" => "Studies show patients using My Medicine have 87% better medication adherence."
        ],
        [
            "icon" => "heart",
            "title" => "Better Health Outcomes",
            "description" => "Regular medication tracking leads to improved management of chronic conditions."
        ],
        [
            "icon" => "trending-up",
            "title" => "Reduced Hospitalizations",
            "description" => "Patients using medication reminders see 32% fewer hospital visits."
        ],
        [
            "icon" => "zap",
            "title" => "Less Stress",
            "description" => "Automate your health management and reduce the daily stress of medication tracking."
        ]
    ];
    $gallery = [
        [
            "title" => "Panadol Extra",
            "description" => "Fast-acting pain relief for headaches and fever",
            "image" => "images/medicines/panadol-extra-tablets-100s.webp"
        ],
        [
            "title" => "Amoxicillin",
            "description" => "Broad-spectrum antibiotic for bacterial infections",
            "image" => "images/medicines/AMOXICILLIN-SODIUM-INJECTION.png"
        ],
        [
            "title" => "Claritin",
            "description" => "24-hour relief from allergy symptoms",
            "image" => "images/medicines/Claritin.webp"
        ],
        [
            "title" => "Centrum Multivitamin",
            "description" => "Complete daily nutrition supplement",
            "image" => "images/medicines/Centrum Multivitamin.jpg"
        ],
        [
            "title" => "Nexium",
            "description" => "Relief from acid reflux and heartburn",
            "image" => "images/medicines/Nexium.webp"
        ],
        [
            "title" => "Advil Liquid-Gels",
            "description" => "Fast-acting anti-inflammatory for pain relief",
            "image" => "images/medicines/Advil Liquid-Gels.jpeg"
        ],
        [
            "title" => "Benadryl",
            "description" => "Antihistamine for allergies and sleep aid",
            "image" => "images/medicines/Benadryl.jpg"
        ],
        [
            "title" => "Metformin",
            "description" => "Oral medication for managing type 2 diabetes",
            "image" => "images/medicines/Metformin.jpg"
        ]
    ];
    $footerLinks = [
        "Company" => [
            "About" => "#",
            "Careers" => "#",
            "Blog" => "#",
            "Press" => "#"
        ],
        "Product" => [
            "Pricing" => "#",
            "Security" => "#",
            "FAQ" => "#"
        ],
        "Resources" => [
            "Help Center" => "#",
            "Guides" => "#",
            "API Documentation" => "#",
            "Community" => "#"
        ],
        "Contact Us" => [
            "muhammedbakr803@gmail.com" => "mailto:muhammedbakr803@gmail.com",
            "+9647700850705" => "tel:+9647700850705",
            "Live Chat" => "#"
        ]
    ];
    $references = [
        [
            "icon" => "globe",
            "title" => "World Health Organization (WHO)",
            "url" => "https://www.who.int/"
        ],
        [
            "icon" => "shield-check",
            "title" => "Centers for Disease Control and Prevention (CDC)",
            "url" => "https://www.cdc.gov/"
        ],
        [
            "icon" => "book-open",
            "title" => "PubMed (U.S. National Library of Medicine)",
            "url" => "https://pubmed.ncbi.nlm.nih.gov/"
        ],
        [
            "icon" => "file-text",
            "title" => "NIH Public Access (PMC)",
            "url" => "https://www.ncbi.nlm.nih.gov/pmc/"
        ]
    ];
    ?>

    <!-- Preloader -->
    <div class="preloader" id="preloader">
        <div class="preloader-inner">
            <i data-lucide="heart" class="preloader-heart w-full h-full"></i>
        </div>
    </div>

    <!-- Navigation Header -->
    <header class="bg-white shadow-sm fixed w-full z-50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between h-16">
                <div class="flex items-center">
                    <div class="flex-shrink-0 flex items-center">
                        <a href="#" onclick="window.scrollTo({top: 0, behavior: 'smooth'}); return false;" class="flex items-center focus:outline-none">
                            <i data-lucide="heart" class="h-8 w-8 text-primary pulse-icon"></i>
                            <span class="ml-2 text-2xl font-bold text-gray-900">
                                <?php echo explode(" ", $appName)[0]; ?><span class="text-primary"><?php echo explode(" ", $appName)[1]; ?></span>
                            </span>
                        </a>
                    </div>
                    <nav class="hidden md:ml-10 md:flex md:space-x-8">
                        <?php 
                        $i = 0;
                        foreach ($navItems as $name => $href): 
                            $isActive = $i === 0;
                            $i++;
                        ?>
                            <a href="<?php echo $href; ?>" class="<?php echo $isActive ? 'text-primary font-medium border-b-2 border-primary' : 'text-gray-500 hover:text-gray-900 font-medium'; ?> px-1 pt-1 pb-2 transition-all duration-300 hover:scale-110">
                                <?php echo $name; ?>
                            </a>
                        <?php endforeach; ?>
                    </nav>
                </div>
                <div class="hidden md:flex items-center space-x-4">
                    <a href="#download" class="px-4 py-2 text-sm font-medium text-white bg-primary hover:bg-primary-dark rounded-md btn-animate transition-transform duration-300 hover:scale-105">
                        Get Started
                    </a>
                </div>
                <div class="flex md:hidden">
                    <button id="mobile-menu-button" class="inline-flex items-center justify-center p-2 rounded-md text-gray-400 hover:text-gray-500 hover:bg-gray-100 focus:outline-none">
                        <i data-lucide="menu" class="h-6 w-6" id="menu-icon"></i>
                        <i data-lucide="x" class="h-6 w-6 hidden" id="close-icon"></i>
                    </button>
                </div>
            </div>
        </div>
        
        <!-- Mobile menu -->
        <div class="md:hidden hidden" id="mobile-menu">
            <div class="pt-2 pb-3 space-y-1">
                <?php 
                $i = 0;
                foreach ($navItems as $name => $href): 
                    $isActive = $i === 0;
                    $i++;
                ?>
                    <a href="<?php echo $href; ?>" class="block pl-3 pr-4 py-2 text-base font-medium <?php echo $isActive ? 'text-primary bg-primary-50 border-l-4 border-primary' : 'text-gray-500 hover:text-gray-900 hover:bg-gray-50 border-l-4 border-transparent'; ?>">
                        <?php echo $name; ?>
                    </a>
                <?php endforeach; ?>
            </div>
            <div class="pt-4 pb-3 border-t border-gray-200">
                <div class="flex items-center px-4">
                    <div class="flex-shrink-0">
                        <i data-lucide="user" class="h-10 w-10 text-gray-400 bg-gray-100 rounded-full p-2"></i>
                    </div>
                    <div class="ml-3">
                        <div class="text-base font-medium text-gray-800">Log In</div>
                        <div class="text-sm font-medium text-gray-500">Get Started</div>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <!-- Hero Section with Animated Background -->
    <div class="hero-section relative bg-white overflow-hidden pt-16">
        <!-- Animated background blobs -->
        <div class="hero-background">
            <div class="animated-blob blob-1"></div>
            <div class="animated-blob blob-2"></div>
            <div class="animated-blob blob-3"></div>
        </div>
        
        <div class="max-w-7xl mx-auto hero-content">
            <div class="relative z-10 pb-8 bg-white sm:pb-16 md:pb-20 lg:max-w-2xl lg:w-full lg:pb-28 xl:pb-32" data-aos="fade-right" data-aos-duration="1000">
                <svg
                    class="hidden lg:block absolute right-0 inset-y-0 h-full w-48 text-white transform translate-x-1/2"
                    fill="currentColor"
                    viewBox="0 0 100 100"
                    preserveAspectRatio="none"
                    aria-hidden="true"
                >
                    <polygon points="50,0 100,0 50,100 0,100" />
                </svg>

                <main class="pt-10 mx-auto max-w-7xl px-4 sm:pt-12 sm:px-6 md:pt-16 lg:pt-20 lg:px-8 xl:pt-28">
                    <div class="sm:text-center lg:text-left">
                        <h1 class="text-4xl tracking-tight font-extrabold text-gray-900 sm:text-5xl md:text-6xl">
                            <span class="block" data-aos="fade-up" data-aos-delay="200">Your Health,</span>
                            <span class="block text-primary" data-aos="fade-up" data-aos-delay="400">In Your Hands</span>
                        </h1>
                        <p class="mt-3 text-base text-gray-500 sm:mt-5 sm:text-lg sm:max-w-xl sm:mx-auto md:mt-5 md:text-xl lg:mx-0" data-aos="fade-up" data-aos-delay="600">
                            <?php echo $appName; ?> helps you manage your medications, track your health, and stay connected with your healthcare providers. All in one secure, easy-to-use application.
                        </p>
                        <div class="mt-5 sm:mt-8 sm:flex sm:justify-center lg:justify-start" data-aos="fade-up" data-aos-delay="800">
                            <div class="rounded-md shadow">
                                <a
                                    href="#download"
                                    class="w-full flex items-center justify-center px-8 py-3 border border-transparent text-base font-medium rounded-md text-white bg-primary hover:bg-primary-dark md:py-4 md:text-lg md:px-10 btn-animate"
                                >
                                    <i data-lucide="download" class="mr-2 h-5 w-5"></i>
                                    Download App
                                </a>
                            </div>
                            <div class="mt-3 sm:mt-0 sm:ml-3">
                                <a
                                    href="#benefits"
                                    class="w-full flex items-center justify-center px-8 py-3 border border-transparent text-base font-medium rounded-md text-primary bg-primary-50 hover:bg-primary-100 md:py-4 md:text-lg md:px-10 transition-all duration-300 hover:shadow-lg"
                                >
                                    <i data-lucide="chevron-down" class="mr-2 h-5 w-5 bounce"></i>
                                    Learn More
                                </a>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <!-- Hero Image with Animation -->
        <div class="lg:absolute lg:inset-y-0 lg:right-0 lg:w-1/2" data-aos="zoom-in" data-aos-duration="1000">
            <div class="relative h-full">
                <!-- Decorative elements -->
                <div class="absolute -top-10 -left-10 w-20 h-20 bg-primary-50 rounded-full spin-slow"></div>
                <div class="absolute bottom-20 right-10 w-12 h-12 bg-primary-100 rounded-full spin-slow" style="animation-direction: reverse;"></div>
                
                <!-- Main image -->
                <img
                    class="h-56 w-full object-cover sm:h-72 md:h-96 lg:w-full lg:h-full float"
                    src="https://source.unsplash.com/random/1200x800/?health,doctor,medical,app"
                    alt="Doctor using medical app"
                />
                
                <!-- Overlaid animated elements -->
                <div class="absolute top-1/4 left-1/4 transform -translate-x-1/2 -translate-y-1/2">
                    <div class="w-16 h-16 bg-white rounded-full shadow-lg flex items-center justify-center bounce">
                        <i data-lucide="heart-pulse" class="h-8 w-8 text-primary"></i>
                    </div>
                </div>
                <div class="absolute bottom-1/4 right-1/4 transform translate-x-1/2 translate-y-1/2">
                    <div class="w-16 h-16 bg-white rounded-full shadow-lg flex items-center justify-center" data-aos="zoom-in" data-aos-delay="1200">
                        <i data-lucide="pill" class="h-8 w-8 text-primary"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Medical References Section -->
    <section class="py-12 bg-white" id="references" data-aos="fade-up">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center mb-10">
                <h2 class="text-3xl font-extrabold text-gray-900">Medical References</h2>
                <p class="mt-2 text-gray-600">Our health recommendations are based on trusted medical sources.</p>
            </div>
            <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-6">
                <?php foreach ($references as $index => $ref): ?>
                <a href="<?php echo $ref['url']; ?>" target="_blank" class="block bg-white rounded-lg shadow-md hover:shadow-xl transition-shadow duration-300 p-6 text-center group border border-gray-100 hover:border-primary" data-aos="fade-up" data-aos-delay="<?php echo $index * 100; ?>">
                    <div class="flex items-center justify-center h-12 w-12 rounded-full bg-primary-50 text-primary mx-auto mb-4">
                        <i data-lucide="<?php echo $ref['icon']; ?>" class="h-6 w-6"></i>
                    </div>
                    <div class="text-lg font-semibold text-gray-900 group-hover:text-primary transition-colors duration-300">
                        <?php echo $ref['title']; ?>
                    </div>
                </a>
                <?php endforeach; ?>
            </div>
        </div>
    </section>

    <!-- Stats Section -->
    <div class="bg-primary-50 py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="grid grid-cols-2 gap-4 md:grid-cols-4">
                <?php
                $stats = [
                    ["number" => "100+", "label" => "Active Users", "icon" => "users"],
                    ["number" => "98%", "label" => "Satisfaction Rate", "icon" => "heart"],
                    ["number" => "30+", "label" => "Reminders Sent", "icon" => "bell"],
                    ["number" => "20+", "label" => "Healthcare Partners", "icon" => "building-2"]
                ];
                
                foreach ($stats as $index => $stat):
                ?>
                <div class="bg-white rounded-lg p-6 shadow-sm text-center" data-aos="fade-up" data-aos-delay="<?php echo $index * 100; ?>">
                    <div class="inline-flex items-center justify-center h-12 w-12 rounded-md bg-primary-100 text-primary mb-4 mx-auto">
                        <i data-lucide="<?php echo $stat['icon']; ?>" class="h-6 w-6"></i>
                    </div>
                    <h3 class="text-3xl font-bold text-gray-900" id="stat-<?php echo $index; ?>"><?php echo $stat['number']; ?></h3>
                    <p class="mt-2 text-sm text-gray-500"><?php echo $stat['label']; ?></p>
                </div>
                <?php endforeach; ?>
            </div>
        </div>
    </div>

    <!-- Benefits Section with Animation -->
    <div class="py-12 bg-white" id="benefits">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="lg:text-center" data-aos="fade-up">
                <h2 class="text-base text-primary font-semibold tracking-wide uppercase">Benefits</h2>
                <p class="mt-2 text-3xl leading-8 font-extrabold tracking-tight text-gray-900 sm:text-4xl">
                    Why Choose <?php echo $appName; ?>?
                </p>
            </div>

            <div class="mt-10">
                <div class="flex flex-col lg:flex-row">
                    <div class="lg:w-1/2 mb-10 lg:mb-0 relative" data-aos="fade-right">
                        <img src="images/logo/logo.png" alt="Doctor consulting with patient" class="rounded-lg shadow-xl max-w-full h-auto" />
                        
                        <!-- Floating elements -->
                        <div class="absolute top-10 -left-5 w-20 h-20 bg-primary-100 rounded-lg shadow-lg flex items-center justify-center transform -rotate-6 float">
                            <i data-lucide="stethoscope" class="h-10 w-10 text-primary"></i>
                        </div>
                        
                        <div class="absolute bottom-10 -right-5 w-24 h-24 bg-primary-50 rounded-lg shadow-lg flex items-center justify-center transform rotate-12 float" style="animation-delay: 2s;">
                            <i data-lucide="clipboard-check" class="h-12 w-12 text-primary"></i>
                        </div>
                    </div>
                    
                    <div class="lg:w-1/2 lg:pl-16">
                        <?php foreach ($benefits as $index => $benefit): ?>
                        <div class="mb-8 flex" data-aos="fade-up" data-aos-delay="<?php echo $index * 100; ?>">
                            <div class="mr-4 flex-shrink-0">
                                <div class="flex items-center justify-center h-12 w-12 rounded-md bg-primary text-white">
                                    <i data-lucide="<?php echo $benefit['icon']; ?>" class="h-6 w-6"></i>
                                </div>
                            </div>
                            <div>
                                <h4 class="text-lg leading-6 font-medium text-gray-900"><?php echo $benefit['title']; ?></h4>
                                <p class="mt-2 text-base text-gray-500"><?php echo $benefit['description']; ?></p>
                            </div>
                        </div>
                        <?php endforeach; ?>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Image Gallery Section -->
    <div class="py-12 bg-gray-100" id="gallery">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center mb-12" data-aos="fade-up">
                <h2 class="text-base text-primary font-semibold tracking-wide uppercase">Gallery</h2>
                <p class="mt-2 text-3xl leading-8 font-extrabold tracking-tight text-gray-900 sm:text-4xl">
                    See <?php echo $appName; ?> in Different Scenarios
                </p>
            </div>
            
            <div class="gallery-grid" data-aos="fade-up">
                <?php foreach ($gallery as $index => $item): ?>
                <div class="gallery-item" data-aos="zoom-in" data-aos-delay="<?php echo $index * 50; ?>">
                    <img src="<?php echo $item['image']; ?>" alt="<?php echo $item['title']; ?>" />
                    <div class="gallery-overlay">
                        <h3 class="text-lg font-bold"><?php echo $item['title']; ?></h3>
                        <p class="text-sm"><?php echo $item['description']; ?></p>
                    </div>
                </div>
                <?php endforeach; ?>
            </div>
        </div>
    </div>

    <!-- Download CTA -->
    <div class="bg-primary-50" id="download">
        <div class="max-w-7xl mx-auto py-12 px-4 sm:px-6 lg:py-16 lg:px-8" data-aos="fade-up">
            <div class="bg-primary rounded-2xl shadow-xl overflow-hidden">
                <div class="pt-10 pb-12 px-6 sm:pt-16 sm:px-16 lg:py-16 lg:pr-0 xl:py-20 xl:px-20">
                    <div class="lg:self-center lg:flex lg:items-center lg:justify-between">
                        <div>
                            <h2 class="text-3xl font-extrabold text-white sm:text-4xl">
                                <span class="block">Ready to take control of your health?</span>
                                <span class="block">Download <?php echo $appName; ?> today.</span>
                            </h2>
                            <p class="mt-4 text-lg leading-6 text-white opacity-75">
                                Available on iOS and Android devices. Free to download and easy to get started.
                            </p>
                            <div class="mt-8 flex space-x-4">
                                <a href="https://apps.apple.com/us/app/medicines-%D8%AF%DB%95%D8%B1%D9%85%D8%A7%D9%86/id6745475446" class="inline-flex items-center px-6 py-3 border border-transparent rounded-md shadow-sm text-base font-medium text-primary bg-white hover:bg-gray-100 transition-all duration-300 hover:scale-105">
                                    <svg class="h-6 w-6 mr-2" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                                        <path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.81-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M13 3.5c.73-.83 1.94-1.46 2.94-1.5.13 1.17-.34 2.35-1.04 3.19-.69.85-1.83 1.51-2.95 1.42-.15-1.15.41-2.35 1.05-3.11z"/>
                                    </svg>
                                    App Store
                                </a>
                                <a href="#" class="inline-flex items-center px-6 py-3 border border-transparent rounded-md shadow-sm text-base font-medium text-white bg-primary-dark hover:bg-primary-900 transition-all duration-300 hover:scale-105">
                                    <svg class="h-6 w-6 mr-2" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                                        <path d="M3.609 1.814L13.792 12L3.609 22.186C3.339 21.859 3.18 21.446 3.18 21V3C3.18 2.554 3.339 2.141 3.609 1.814ZM14.83 13.038L17.196 14.383L7.403 19.205C7.124 19.345 6.818 19.42 6.5 19.42C6.182 19.42 5.876 19.345 5.598 19.205L14.83 13.038ZM17.93 8.71L20.66 10.334C21.144 10.617 21.144 11.383 20.66 11.666L17.196 13.617L14.83 12.272L17.93 8.71ZM5.598 4.795C5.876 4.655 6.182 4.58 6.5 4.58C6.818 4.58 7.124 4.655 7.403 4.795L17.196 9.617L14.83 10.962L5.598 4.795Z"/>
                                    </svg>
                                    Google Play
                                </a>
                            </div>
                        </div>
                        <div class="mt-8 lg:mt-0 lg:flex-shrink-0">
                            <div class="relative mx-auto h-80 w-80 lg:h-96 lg:w-96" data-aos="fade-left">
                                <img src="images/logo/logo.png" alt="App on smartphone" class="relative z-10 rounded-lg shadow-2xl float" />
                                
                                <!-- Decorative elements -->
                                <div class="absolute top-1/4 -left-10 w-20 h-20 bg-white rounded-full shadow-lg flex items-center justify-center pulse-icon">
                                    <i data-lucide="heart" class="h-10 w-10 text-primary"></i>
                                </div>
                                
                                <div class="absolute bottom-1/4 -right-10 w-20 h-20 bg-white rounded-full shadow-lg flex items-center justify-center float" style="animation-delay: 2s;">
                                    <i data-lucide="pill" class="h-10 w-10 text-primary"></i>
                                </div>
                                
                                <div class="absolute -bottom-10 left-1/2 transform -translate-x-1/2 w-24 h-24 bg-white rounded-full shadow-lg flex items-center justify-center bounce">
                                    <i data-lucide="activity" class="h-12 w-12 text-primary"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-gray-800" id="contact">
        <div class="max-w-7xl mx-auto py-12 px-4 sm:px-6 lg:py-16 lg:px-8">
            <div class="grid grid-cols-2 gap-8 md:grid-cols-4">
                <?php 
                $delay = 100;
                foreach ($footerLinks as $category => $links): 
                ?>
                <div data-aos="fade-up" data-aos-delay="<?php echo $delay; ?>">
                    <h3 class="text-sm font-semibold text-gray-400 tracking-wider uppercase"><?php echo $category; ?></h3>
                    <ul class="mt-4 space-y-4">
                        <?php foreach ($links as $name => $href): ?>
                        <li><a href="<?php echo $href; ?>" class="text-base text-gray-300 hover:text-white transition-all duration-300 hover:translate-x-1 inline-block"><?php echo $name; ?></a></li>
                        <?php endforeach; ?>
                    </ul>
                </div>
                <?php 
                $delay += 100;
                endforeach; 
                ?>
            </div>
            <div class="mt-8 border-t border-gray-700 pt-8 md:flex md:items-center md:justify-between">
                <div class="flex space-x-6 md:order-2" data-aos="fade-left">
                    <a href="#" class="text-gray-400 hover:text-gray-300 transition-transform duration-300 hover:scale-125">
                        <span class="sr-only">Facebook</span>
                        <svg class="h-6 w-6" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                            <path fill-rule="evenodd" d="M22 12c0-5.523-4.477-10-10-10S2 6.477 2 12c0 4.991 3.657 9.128 8.438 9.878v-6.987h-2.54V12h2.54V9.797c0-2.506 1.492-3.89 3.777-3.89 1.094 0 2.238.195 2.238.195v2.46h-1.26c-1.243 0-1.63.771-1.63 1.562V12h2.773l-.443 2.89h-2.33v6.988C18.343 21.128 22 16.991 22 12z" clip-rule="evenodd" />
                        </svg>
                    </a>
                    <a href="#" class="text-gray-400 hover:text-gray-300 transition-transform duration-300 hover:scale-125">
                        <span class="sr-only">Twitter</span>
                        <svg class="h-6 w-6" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                            <path d="M8.29 20.251c7.547 0 11.675-6.253 11.675-11.675 0-.178 0-.355-.012-.53A8.348 8.348 0 0022 5.92a8.19 8.19 0 01-2.357.646 4.118 4.118 0 001.804-2.27 8.224 8.224 0 01-2.605.996 4.107 4.107 0 00-6.993 3.743 11.65 11.65 0 01-8.457-4.287 4.106 4.106 0 001.27 5.477A4.072 4.072 0 012.8 9.713v.052a4.105 4.105 0 003.292 4.022 4.095 4.095 0 01-1.853.07 4.108 4.108 0 003.834 2.85A8.233 8.233 0 012 18.407a11.616 11.616 0 006.29 1.84" />
                        </svg>
                    </a>
                    <a href="#" class="text-gray-400 hover:text-gray-300 transition-transform duration-300 hover:scale-125">
                        <span class="sr-only">Instagram</span>
                        <svg class="h-6 w-6" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                            <path fill-rule="evenodd" d="M12.315 2c2.43 0 2.784.013 3.808.06 1.064.049 1.791.218 2.427.465a4.902 4.902 0 011.772 1.153 4.902 4.902 0 011.153 1.772c.247.636.416 1.363.465 2.427.048 1.067.06 1.407.06 4.123v.08c0 2.643-.012 2.987-.06 4.043-.049 1.064-.218 1.791-.465 2.427a4.902 4.902 0 01-1.153 1.772 4.902 4.902 0 01-1.772 1.153c-.636.247-1.363.416-2.427.465-1.067.048-1.407.06-4.123.06h-.08c-2.643 0-2.987-.012-4.043-.06-1.064-.049-1.791-.218-2.427-.465a4.902 4.902 0 01-1.772-1.153 4.902 4.902 0 01-1.153-1.772c-.247-.636-.416-1.363-.465-2.427-.047-1.024-.06-1.379-.06-3.808v-.63c0-2.43.013-2.784.06-3.808.049-1.064.218-1.791.465-2.427a4.902 4.902 0 011.153-1.772A4.902 4.902 0 015.45 2.525c.636-.247 1.363-.416 2.427-.465C8.901 2.013 9.256 2 11.685 2h.63zm-.081 1.802h-.468c-2.456 0-2.784.011-3.807.058-.975.045-1.504.207-1.857.344-.467.182-.8.398-1.15.748-.35.35-.566.683-.748 1.15-.137.353-.3.882-.344 1.857-.047 1.023-.058 1.351-.058 3.807v.468c0 2.456.011 2.784.058 3.807.045.975.207 1.504.344 1.857.182.466.399.8.748 1.15.35.35.683.566 1.15.748.353.137.882.3 1.857.344 1.054.048 1.37.058 4.041.058h.08c2.597 0 2.917-.01 3.96-.058.976-.045 1.505-.207 1.858-.344.466-.182.8-.398 1.15-.748.35-.35.566-.683.748-1.15.137-.353.3-.882.344-1.857.048-1.055.058-1.37.058-4.041v-.08c0-2.597-.01-2.917-.058-3.96-.045-.976-.207-1.505-.344-1.858a3.097 3.097 0 00-.748-1.15 3.098 3.098 0 00-1.15-.748c-.353-.137-.882-.3-1.857-.344-1.023-.047-1.351-.058-3.807-.058zM12 6.865a5.135 5.135 0 110 10.27 5.135 5.135 0 010-10.27zm0 1.802a3.333 3.333 0 100 6.666 3.333 3.333 0 000-6.666zm5.338-3.205a1.2 1.2 0 110 2.4 1.2 1.2 0 010-2.4z" clip-rule="evenodd" />
                        </svg>
                    </a>
                </div>
                <p class="mt-8 text-base text-gray-400 md:mt-0 md:order-1" data-aos="fade-right">
                    &copy; <?php echo date('Y'); ?> <?php echo $appName; ?>. All rights reserved.
                </p>
            </div>
        </div>
    </footer>

    <!-- Back to top button -->
    <button id="back-to-top" class="fixed bottom-4 right-4 p-2 rounded-full bg-primary text-white shadow-lg opacity-0 transition-opacity duration-300 hover:bg-primary-dark">
        <i data-lucide="chevron-up" class="h-6 w-6"></i>
    </button>

    <!-- JavaScript for Mobile Menu Toggle and Animations -->
    <script src="js/main.js"></script>
</body>
</html>
