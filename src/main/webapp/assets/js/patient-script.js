// DOM Elements
document.addEventListener('DOMContentLoaded', function() {
    const sidebar = document.getElementById('sidebar');
    const mainContent = document.getElementById('mainContent');
    const topbar = document.getElementById('topbar');
    const toggleSidebarBtn = document.getElementById('toggleSidebar');
    const mobileOverlay = document.getElementById('mobileOverlay');
    const themeToggle = document.getElementById('themeToggle');
    const themeIcon = document.getElementById('themeIcon');
    const htmlElement = document.documentElement;

    // Check for saved theme preference
    const currentTheme = localStorage.getItem('theme') || 'light';
    htmlElement.setAttribute('data-theme', currentTheme);
    updateThemeIcon(currentTheme);

    // Theme Toggle Function
    themeToggle.addEventListener('click', function() {
        let theme = htmlElement.getAttribute('data-theme');
        let newTheme = theme === 'light' ? 'dark' : 'light';

        htmlElement.setAttribute('data-theme', newTheme);
        localStorage.setItem('theme', newTheme);
        updateThemeIcon(newTheme);
    });

    function updateThemeIcon(theme) {
        if (theme === 'dark') {
            themeIcon.classList.remove('fa-moon');
            themeIcon.classList.add('fa-sun');
        } else {
            themeIcon.classList.remove('fa-sun');
            themeIcon.classList.add('fa-moon');
        }
    }

    // Check screen width
    function checkScreenWidth() {
        const isDesktop = window.innerWidth >= 992;
        return isDesktop;
    }

    // Toggle sidebar based on device
    function toggleSidebar() {
        const isDesktop = checkScreenWidth();
        if (isDesktop) {
            sidebar.classList.toggle('collapsed');
            mainContent.classList.toggle('expanded');
            topbar.classList.toggle('expanded');
        } else {
            sidebar.classList.toggle('mobile-visible');
            mobileOverlay.classList.toggle('active');
        }
    }

    // Event Listeners
    if (toggleSidebarBtn) {
        toggleSidebarBtn.addEventListener('click', toggleSidebar);
    }

    if (mobileOverlay) {
        mobileOverlay.addEventListener('click', function() {
            sidebar.classList.remove('mobile-visible');
            mobileOverlay.classList.remove('active');
        });
    }

    // On resize
    window.addEventListener('resize', function() {
        const isDesktop = checkScreenWidth();
        if (isDesktop) {
            sidebar.classList.remove('mobile-visible');
            mobileOverlay.classList.remove('active');
        }
    });

    // Success message display and auto-hide
    const alerts = document.querySelectorAll('.alert');
    if (alerts.length > 0) {
        setTimeout(function() {
            alerts.forEach(function(alert) {
                alert.style.transition = 'opacity 0.5s ease';
                alert.style.opacity = '0';
                setTimeout(function() {
                    alert.remove();
                }, 500);
            });
        }, 5000);
    }
});