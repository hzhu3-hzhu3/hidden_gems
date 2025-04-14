import { Controller } from "@hotwired/stimulus"
import { Dropdown } from "bootstrap"

export default class extends Controller {
  connect() {
    this.dropdown = new Dropdown(this.element)
  }
  
  disconnect() {
    if (this.dropdown) {
      this.dropdown.dispose()
    }
  }
  
  toggle(event) {
    event.stopPropagation()
    this.dropdown.toggle()
  }
}