
// Dropdown del menú de usuario
const userMenu = document.querySelector('.user-menu');
const dropdownMenu = document.querySelector('.dropdown-menu-user');

if (userMenu && dropdownMenu) {
  userMenu.addEventListener('click', (e) => {
    e.preventDefault();
    dropdownMenu.classList.toggle('show');
  });
  
  // Cerrar al hacer clic fuera
  document.addEventListener('click', (e) => {
    if (!userMenu.contains(e.target) && !dropdownMenu.contains(e.target)) {
      dropdownMenu.classList.remove('show');
    }
  });
}

// Para móvil: toggle sidebar
function toggleSidebar() {
  document.querySelector('.sidebar').classList.toggle('open');
}

// Dropdown genérico para todos los .lv-dropdown
document.querySelectorAll('.lv-dropdown').forEach(dropdown => {
  const toggle = dropdown.querySelector('.lv-dropdown-toggle');
  const menu = dropdown.querySelector('.lv-dropdown-menu');

  toggle.addEventListener('click', (e) => {
    e.preventDefault();
    e.stopPropagation();
    // Cierra otros dropdowns abiertos
    document.querySelectorAll('.lv-dropdown-menu.show').forEach(m => {
      if (m !== menu) m.classList.remove('show');
    });
    menu.classList.toggle('show');
  });
});

// Cierra cualquier dropdown al hacer clic fuera
document.addEventListener('click', () => {
  document.querySelectorAll('.lv-dropdown-menu.show').forEach(m => {
    m.classList.remove('show');
  });
});

document.addEventListener('click', async function(e) {
    const btn = e.target.closest('[data-id]');
    if (!btn) return;

    const productId = btn.dataset.id;

    const res = await fetch(`/cart/add/${productId}`, { method: 'POST' });
    const data = await res.json();

    if (data.success) {
        const badge = document.getElementById('cart-badge');
        badge.textContent = data.count;
        badge.style.display = 'inline-flex';

        // Feedback visual en el botón
        btn.textContent = '✓ Añadido';
        setTimeout(() => btn.textContent = 'Añadir al carrito +', 1500);
    }
});
