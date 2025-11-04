// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"

// === Flatpickr setup ===
document.addEventListener("turbo:load", () => {
  if (window.flatpickr) {
    flatpickr("input[placeholder='Add dates']", {
      mode: "range",
      altInput: true,
      altFormat: "F j, Y",
      dateFormat: "Y-m-d",
      allowInput: true,
    });
  }
});

// === Collapser logic ===
document.addEventListener("click", (e) => {
  const btn = e.target.closest("[data-collapser-target]");
  if (!btn) return;
  e.preventDefault();
  const id = btn.getAttribute("data-collapser-target");
  const el = id ? document.getElementById(id) : null;
  if (!el) return;
  el.classList.toggle("show");
  const expanded = el.classList.contains("show");
  btn.setAttribute("aria-expanded", expanded ? "true" : "false");
}, { passive: false });

// === FIX FOR DUPLICATED PLACEHOLDERS ===
document.addEventListener("turbo:before-cache", () => {
  if (window.flatpickr) {
    document.querySelectorAll(".flatpickr-input").forEach((el) => {
      if (el._flatpickr) {
        el._flatpickr.destroy();
      }
    });
  }
});

// === Flatpickr for birthdate field ===
document.addEventListener("turbo:load", () => {
  if (window.flatpickr) {
    flatpickr(".flatpickr-birthdate", {
      altInput: true,
      altFormat: "F j, Y",
      dateFormat: "Y-m-d",
      maxDate: "today",
      defaultDate: null,
      disableMobile: true,
      yearRange: [1900, new Date().getFullYear()],
    });
  }
});
