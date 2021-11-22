const Name = {
  mounted() {
    this.el.addEventListener('focusout', (e)  => {
      this.pushEvent("update-content-name", {name: this.el.innerText, id: this.el.dataset.selectedId});
    });
  }
}

export default Name
