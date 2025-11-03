import { Controller } from "@hotwired/stimulus"

// data-controller="gallery"
export default class extends Controller {
  static targets = ["item"]
  static values = {
    modalId: String,     // z.B. "galleryModal"
    carouselId: String,  // z.B. "listingCarousel"
    rootMargin: { type: String, default: "200px" }
  }

  connect() {
    this._setupLazyObserver()
  }

  disconnect() {
    if (this.observer) this.observer.disconnect()
  }

  open(event) {
    event.preventDefault()
    const index = parseInt(event.currentTarget.dataset.index || "0", 10)

    const modalEl = document.getElementById(this.modalIdValue)
    const carouselEl = document.getElementById(this.carouselIdValue)

    const modal = bootstrap.Modal.getOrCreateInstance(modalEl)
    const carousel = bootstrap.Carousel.getOrCreateInstance(carouselEl, { interval: false, ride: false })

    modal.show()
    // nach Öffnen zum geklickten Slide springen
    setTimeout(() => carousel.to(index), 50)
  }

  _setupLazyObserver() {
    this.observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (!entry.isIntersecting) return
        const el = entry.target
        const src = el.dataset.src
        if (src) {
          el.style.backgroundImage = `url("${src}")`
          el.classList.add("loaded")
          el.removeAttribute("data-src")
        }
        this.observer.unobserve(el)
      })
    }, { rootMargin: this.rootMarginValue })

    this.itemTargets.forEach(el => this.observer.observe(el))
  }
}
