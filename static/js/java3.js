
const sectionMap = {
            'directorio': 'directorio-section',
            'registro': 'registro-section',
            'permisos': 'permisos-section',
            'metricas': 'metricas-section',
            // Comercial y otros
            'pedidos': 'pedidos-section',
            'compras': 'compras-section',
            'seguimiento': 'seguimiento-section',
            'productos': 'productos-section',
            'clasificaciones': 'clasificaciones-section',
            'puntosEntrega': 'puntosEntrega-section',
            'pagos': 'pagos-section',
            // Top nav
            'dashboard': 'dashboard-section',
            'clientes': 'clientes-section',
            'inventario': 'inventario-section',
            'transacciones': 'transacciones-section'
        };

        // Obtener todas las secciones
        const allSections = document.querySelectorAll('.content-section');
        
        function showSection(sectionId) {
            // Ocultar todas
            allSections.forEach(section => {
                section.classList.remove('active-section');
            });
            // Mostrar la elegida
            const target = document.getElementById(sectionId);
            if (target) {
                target.classList.add('active-section');
            } else {
                // fallback a dashboard si no existe
                document.getElementById('dashboard-section').classList.add('active-section');
            }
            // Actualizar clase activa en los enlaces del panel lateral y nav superior
            updateActiveLinks(sectionId);
        }

        function updateActiveLinks(activeSectionId) {
            // Remover clase active-link de todos los <a> del panel lateral
            document.querySelectorAll('.side-panel a').forEach(link => {
                link.classList.remove('active-link');
            });
            document.querySelectorAll('.main-nav a').forEach(link => {
                link.classList.remove('nav-active');
            });
            
            // Buscar coincidencia: recorremos el map para ver qué data-section apunta a esta sección
            for (const [key, secId] of Object.entries(sectionMap)) {
                if (secId === activeSectionId) {
                    // Resaltar en panel lateral: enlace con data-section = key
                    const sideLink = document.querySelector(`.side-panel a[data-section="${key}"]`);
                    if (sideLink) sideLink.classList.add('active-link');
                    // Resaltar top nav si es dashboard, clientes, etc
                    const topLink = document.querySelector(`.main-nav a[data-nav="${key}"]`);
                    if (topLink) topLink.classList.add('nav-active');
                    break;
                }
            }
            // Caso especial: si es dashboard-section, aseguramos nav-active en dashboard
            if (activeSectionId === 'dashboard-section') {
                const dashNav = document.querySelector('.main-nav a[data-nav="dashboard"]');
                if (dashNav) dashNav.classList.add('nav-active');
            }
            if (activeSectionId === 'clientes-section') {
                const clientNav = document.querySelector('.main-nav a[data-nav="clientes"]');
                if (clientNav) clientNav.classList.add('nav-active');
            }
            if (activeSectionId === 'inventario-section') {
                const inventNav = document.querySelector('.main-nav a[data-nav="inventario"]');
                if (inventNav) inventNav.classList.add('nav-active');
            }
            if (activeSectionId === 'transacciones-section') {
                const transacNav = document.querySelector('.main-nav a[data-nav="transacciones"]');
                if (transacNav) transacNav.classList.add('nav-active');
            }
        }

        // Agregar evento a todos los links del panel lateral
        document.querySelectorAll('.side-panel a').forEach(link => {
            link.addEventListener('click', (e) => {
                e.preventDefault();
                const sectionKey = link.getAttribute('data-section');
                if (sectionKey && sectionMap[sectionKey]) {
                    showSection(sectionMap[sectionKey]);
                    // Opcional: guardar en localStorage para recordar última sección
                    localStorage.setItem('lastSection', sectionMap[sectionKey]);
                } else {
                    // si no existe mapeo, mostrar dashboard por defecto
                    showSection('dashboard-section');
                }
            });
        });

        // Navegación superior (Dashboard, Clientes, Inventario, Transacciones)
        document.querySelectorAll('.main-nav a').forEach(navLink => {
            navLink.addEventListener('click', (e) => {
                e.preventDefault();
                const navKey = navLink.getAttribute('data-nav');
                if (navKey && sectionMap[navKey]) {
                    showSection(sectionMap[navKey]);
                    localStorage.setItem('lastSection', sectionMap[navKey]);
                } else {
                    showSection('dashboard-section');
                }
            });
        });

        // Mostrar sección inicial: dashboard por defecto, o la última almacenada
        const last = localStorage.getItem('lastSection');
        if (last && document.getElementById(last)) {
            showSection(last);
        } else {
            showSection('dashboard-section');
        }

        // ------------------------------------------------------------
        // 2. Dropdown del perfil de usuario
        // ------------------------------------------------------------
        const userBtn = document.getElementById('userMenuBtn');
        const userDropdown = document.getElementById('userDropdown');
        if (userBtn) {
            userBtn.addEventListener('click', (e) => {
                e.preventDefault();
                userDropdown.classList.toggle('show');
            });
            document.addEventListener('click', (e) => {
                if (!userBtn.contains(e.target) && !userDropdown.contains(e.target)) {
                    userDropdown.classList.remove('show');
                }
            });
        }