import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
  static targets = ["item"]
  static values = {
    modalId: String,
    carouselId: String,
    rootMargin: { type: String, default: "200px" }
  }

  connect() {
    console.debug("[gallery] connected", {
      modalId: this.modalIdValue,
      carouselId: this.carouselIdValue
    })
    this._setupLazyObserver()
  }

  disconnect() {
    if (this.observer) this.observer.disconnect()
  }

  open(event) {
    event.preventDefault()
    const clickedIndex = parseInt(event.currentTarget.dataset.index || "0", 10)

    // ✅ Bootstrap aus ESM ODER globalem window nehmen
    const bs = (globalThis.bootstrap /* CDN/global */) // eslint-disable-line no-undef
             || (typeof bootstrap !== "undefined" ? bootstrap : null) // falls du den Import wieder aktivierst
    if (!bs) {
      console.error("[gallery] Bootstrap JS nicht gefunden. Lade es via import 'bootstrap' oder CDN.")
      return
    }

    const modalEl = document.getElementById(this.modalIdValue)
    const carouselEl = document.getElementById(this.carouselIdValue)
    if (!modalEl || !carouselEl) {
      console.error("[gallery] Elemente nicht gefunden", { modalEl, carouselEl })
      return
    }

    const modal = bs.Modal.getOrCreateInstance(modalEl)
    const carousel = bs.Carousel.getOrCreateInstance(carouselEl, { interval: false, ride: false })

    const onShown = () => {
      const total = carouselEl.querySelectorAll(".carousel-item").length
      const index = Math.max(0, Math.min(clickedIndex, total - 1))
      carousel.to(index)
      console.debug("[gallery] jumped to slide", index)
    }

    modalEl.addEventListener("shown.bs.modal", onShown, { once: true })
    modal.show()
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
