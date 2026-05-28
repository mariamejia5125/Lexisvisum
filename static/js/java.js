// Primer dropdown
{
  const btn = document.querySelector('.dropdown-toggle');
  const menu = document.querySelector('.dropdown-menu');

  if (btn && menu) {
    btn.addEventListener('click', function(e) {
      e.preventDefault();
      e.stopPropagation();
      menu.classList.toggle('show');
    });

    window.addEventListener('click', function(e) {
      if (!btn.contains(e.target)) {
        menu.classList.remove('show');
      }
    });
  }
}

// Segundo dropdown
{
  const btn = document.querySelector('.dropdown-toggle2');
  const menu = document.querySelector('.dropdown-menu2');

  if (btn && menu) {
    btn.addEventListener('click', function(e) {
      e.preventDefault();
      e.stopPropagation();
      menu.classList.toggle('show');
    });

    window.addEventListener('click', function(e) {
      if (!btn.contains(e.target)) {
        menu.classList.remove('show');
      }
    });
  }
}