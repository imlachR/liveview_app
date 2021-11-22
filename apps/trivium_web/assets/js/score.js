const Score = {
  mounted() {
    this.el.addEventListener('focusout', (e)  => {
      this.pushEvent("update-question-score", {score: this.el.value, id: this.el.dataset.scoreId});
    });
  }
}

export default Score
