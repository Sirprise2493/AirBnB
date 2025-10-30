import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel"]

  connect() {
    // Uncomment to verify it connects in DevTools:
    // console.log("[collapse] connected", this.hasPanelTarget ? "with panel" : "no panel")
  }

  toggle() {
    if (!this.hasPanelTarget) return
    this.panelTarget.classList.toggle("show")
    // keep aria in sync on the button element (this.element is the button)
    const expanded = this.panelTarget.classList.contains("show")
    this.element.setAttribute("aria-expanded", expanded ? "true" : "false")
  }
}
