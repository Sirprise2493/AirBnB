import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "button"]
  static values = {
    expanded: { type: Boolean, default: false },
    collapsedLines: { type: Number, default: 5 }
  }

  connect() {
    this.element.style.setProperty("--line-clamp", this.collapsedLinesValue)
    this.update()
  }

  toggle(event) {
    event.preventDefault()
    this.expandedValue = !this.expandedValue
    this.update()
  }

  update() {
    this.element.classList.toggle("expanded", this.expandedValue)
    this.contentTarget.setAttribute("aria-expanded", this.expandedValue)
    this.buttonTarget.setAttribute("aria-expanded", this.expandedValue)
    this.buttonTarget.textContent = this.expandedValue ? "Show less" : "Show more"
  }
}
