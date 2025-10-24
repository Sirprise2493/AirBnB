// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"
import { Application } from "@hotwired/stimulus"

const application = Application.start()
application.debug = false
window.Stimulus = application

export { application }

document.addEventListener("turbo:load", () => {
  const navbar = document.querySelector(".navbar");
  const miniSearch = document.querySelector(".mini-search-bar");

  if (navbar) {
    window.addEventListener("scroll", () => {
      if (window.scrollY > 100) {
        navbar.classList.add("scrolled");
      } else {
        navbar.classList.remove("scrolled");
      }
    });

    if (miniSearch) {
      miniSearch.addEventListener("click", () => {
        navbar.classList.remove("scrolled");
        window.scrollTo({ top: 0, behavior: "smooth" });
      });
    }
  }

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
