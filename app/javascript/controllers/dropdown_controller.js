import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.addEventListener('click', this.toggle.bind(this))
  }

  toggle(event) {
    event.stopPropagation()
    const dropdown = this.element.nextElementSibling
    if (dropdown && dropdown.classList.contains('dropdown-menu')) {
      dropdown.classList.toggle('show')
    }
  }
}