const Writer = {
  mounted() {

    this.el.addEventListener('focusout', (e)  => {
      this.pushEvent("update-writing", {body: this.el.innerHTML, id: this.el.dataset.mediaId});
    });
  }
}

export default Writer
