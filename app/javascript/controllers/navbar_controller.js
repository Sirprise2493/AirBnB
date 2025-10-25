import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.navbar = this.element
    this.miniSearch = this.navbar.querySelector(".mini-search-bar")
    this.isExpanded = false

    this.handleScroll = this.handleScroll.bind(this)
    this.handleDocClick = this.handleDocClick.bind(this)
    this.handleKeydown = this.handleKeydown.bind(this)
    this.expandMiniSearch = this.expandMiniSearch.bind(this)
    this.collapse = this.collapse.bind(this)

    this.handleScroll()
    window.addEventListener("scroll", this.handleScroll)
    window.addEventListener("load", this.handleScroll)
    document.addEventListener("click", this.handleDocClick, true)
    document.addEventListener("keydown", this.handleKeydown)

    if (this.miniSearch) {
      this.miniSearch.addEventListener("pointerdown", this.expandMiniSearch, { passive: false })
    }
  }

  disconnect() {
    window.removeEventListener("scroll", this.handleScroll)
    window.removeEventListener("load", this.handleScroll)
    document.removeEventListener("click", this.handleDocClick, true)
    document.removeEventListener("keydown", this.handleKeydown)

    if (this.miniSearch) {
      this.miniSearch.removeEventListener("pointerdown", this.expandMiniSearch)
    }
  }

  handleScroll() {
    if (window.scrollY > 100) {
      if (!this.isExpanded) this.navbar.classList.add("scrolled")
    } else {
      this.navbar.classList.remove("scrolled")
    }
  }

  handleDocClick(e) {
    if (this.navbar.contains(e.target)) return
    this.collapse()
  }

  handleKeydown(e) {
    if (e.key === "Escape") this.collapse()
  }

  expandMiniSearch(e) {
    e.preventDefault()
    e.stopPropagation()
    this.isExpanded = true
    this.navbar.classList.add("expanded")
    this.navbar.classList.remove("scrolled")
    requestAnimationFrame(() => {
      const firstInput = this.navbar.querySelector(".search-bar input")
      if (firstInput) firstInput.focus()
    })
  }

  collapse() {
    this.isExpanded = false
    this.navbar.classList.remove("expanded")
    if (window.scrollY > 100) this.navbar.classList.add("scrolled")
  }
}
