document.addEventListener('DOMContentLoaded', function() {
    // Initialize Lucide icons
    lucide.createIcons();
    
    // Handle preloader
    const preloader = document.getElementById('preloader');
    
    window.addEventListener('load', function() {
        preloader.classList.add('fade-out');
        setTimeout(function() {
            preloader.style.display = 'none';
        }, 500);
        
        // Initialize AOS animations
        AOS.init({
            once: false,
            duration: 800,
            easing: 'ease-in-out',
            mirror: true
        });
    });
    
    // Initialize parallax effect for background elements
    const parallaxElements = document.querySelectorAll('.bg-element');
    window.addEventListener('mousemove', function(e) {
        const x = e.clientX / window.innerWidth;
        const y = e.clientY / window.innerHeight;
        
        parallaxElements.forEach(element => {
            const speed = element.getAttribute('data-speed') || 0.05;
            const moveX = (x - 0.5) * 100 * speed;
            const moveY = (y - 0.5) * 100 * speed;
            element.style.transform = `translate(${moveX}px, ${moveY}px)`;
        });
    });
    
    // Counter animation for stats
    const statElements = document.querySelectorAll('[id^="stat-"]');
    const animateCounter = (el, target) => {
        const num = parseFloat(target.replace(/[^\d.-]/g, ''));
        const suffix = target.replace(/[\d.-]/g, '');
        let count = 0;
        const increment = num / 50;
        const timer = setInterval(() => {
            count += increment;
            if (count >= num) {
                clearInterval(timer);
                el.textContent = target;
            } else {
                el.textContent = Math.floor(count) + suffix;
            }
        }, 20);
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const target = entry.target.textContent;
                animateCounter(entry.target, target);
                observer.unobserve(entry.target);
            }
        });
    });
    
    statElements.forEach(stat => {
        observer.observe(stat);
    });
    
    // Mobile menu toggle
    const mobileMenuButton = document.getElementById('mobile-menu-button');
    const mobileMenu = document.getElementById('mobile-menu');
    const menuIcon = document.getElementById('menu-icon');
    const closeIcon = document.getElementById('close-icon');
    
    mobileMenuButton.addEventListener('click', function() {
        mobileMenu.classList.toggle('hidden');
        menuIcon.classList.toggle('hidden');
        closeIcon.classList.toggle('hidden');
    });
    
    // Back to top button
    const backToTopButton = document.getElementById('back-to-top');
    
    window.addEventListener('scroll', function() {
        if (window.pageYOffset > 300) {
            backToTopButton.classList.remove('opacity-0');
            backToTopButton.classList.add('opacity-100');
        } else {
            backToTopButton.classList.remove('opacity-100');
            backToTopButton.classList.add('opacity-0');
        }
    });
    
    backToTopButton.addEventListener('click', function() {
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    });
    
    // Smooth scroll for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                window.scrollTo({
                    top: target.offsetTop - 70, // Adjusted for header height
                    behavior: 'smooth'
                });
                
                // Close mobile menu if open
                if (!mobileMenu.classList.contains('hidden')) {
                    mobileMenu.classList.add('hidden');
                    menuIcon.classList.remove('hidden');
                    closeIcon.classList.add('hidden');
                }
            }
        });
    });
}); 