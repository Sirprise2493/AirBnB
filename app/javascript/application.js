// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"

// Flatpickr setup
// Runs each time Turbo loads a new page (replaces normal DOMContentLoaded for Turbo)
document.addEventListener("turbo:load", () => {
  // Check if Flatpickr library is available
  if (window.flatpickr) {
    // Intialise flatpickr on any input with placeholder 'Add dates'
    flatpickr("input[placeholder='Add dates']", {
      mode: "range", // Allow selecting a start + end date
      altInput: true, // Show user-friendly formatted date
      altFormat: "F j, Y",
      dateFormat: "Y-m-d", // Actual format saved in input for Rails
      allowInput: true, // Let users manually type dates if they want
    });
  }
});


document.addEventListener("click", (e) => {
  const btn = e.target.closest("[data-collapser-target]")
  if (!btn) return
  e.preventDefault()
  const id = btn.getAttribute("data-collapser-target")
  const el = id ? document.getElementById(id) : null
  if (!el) return
  el.classList.toggle("show")
  const expanded = el.classList.contains("show")
  btn.setAttribute("aria-expanded", expanded ? "true" : "false")
}, { passive: false })

// === Flatpickr for birthdate field ===
document.addEventListener("turbo:load", () => {
  if (window.flatpickr) {
    flatpickr(".flatpickr-birthdate", {
      altInput: true,
      altFormat: "F j, Y",
      dateFormat: "Y-m-d",
      maxDate: "today",      // user can’t pick a future date
      defaultDate: null,
      disableMobile: true,   // ensures consistent desktop picker styling
      yearRange: [1900, new Date().getFullYear()], // wide range of years
    });
  }
});
