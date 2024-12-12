import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["togglableElement"]

  connect() {
    console.log("connected")
  }

  fire() {
    console.log("clicked")
    this.togglableElementTarget.classList.toggle("d-none");
  }
}
