// script.js — Interactivity for the Simple WebApp demo

// Wait for DOM ready
document.addEventListener('DOMContentLoaded', function () {
  const btn = document.getElementById('demoBtn');
  if (!btn) {
    // Defensive: log if button is missing
    console.warn('demoBtn not found in DOM.');
    return;
  }

  // When clicked, show a friendly alert.
  btn.addEventListener('click', function () {
    alert('Hello from the Simple WebApp Jenkins CI/CD demo!');
  });
});
