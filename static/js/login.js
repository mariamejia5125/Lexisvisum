const formsWrapper = document.getElementById('formsWrapper');
const overlayWrapper = document.getElementById('overlayWrapper');
const showRegisterBtn = document.getElementById('showRegisterBtn');
const showLoginBtn = document.getElementById('showLoginBtn');

if (showRegisterBtn) {
    showRegisterBtn.addEventListener('click', () => {
        if (formsWrapper) formsWrapper.classList.add('active');
        if (overlayWrapper) overlayWrapper.classList.add('active');
    });
}

if (showLoginBtn) {
    showLoginBtn.addEventListener('click', () => {
        if (formsWrapper) formsWrapper.classList.remove('active');
        if (overlayWrapper) overlayWrapper.classList.remove('active');
    });
}