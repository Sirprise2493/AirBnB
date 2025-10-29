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