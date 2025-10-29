import { Controller } from "@hotwired/stimulus"

// Simple image carousel controller
export default class extends Controller {
  static targets = ["image"]

  connect() {
    this.index = 0
    this.showCurrentImage()
  }

  next() {
    this.index = (this.index + 1) % this.imageTargets.length
    this.showCurrentImage()
  }

  previous() {
    this.index = (this.index - 1 + this.imageTargets.length) % this.imageTargets.length
    this.showCurrentImage()
  }

  // Display only the current image
  showCurrentImage() {
    this.imageTargets.forEach((img, i) => {
      img.classList.toggle("hidden", i !== this.index)
    })
  }
}
