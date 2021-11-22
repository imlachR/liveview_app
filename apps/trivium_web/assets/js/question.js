const Question = {
  mounted() {
    this.el.addEventListener('focusout', (e)  => {
      this.pushEvent("update-question-text", {question_text: this.el.innerText, id: this.el.dataset.questionId});
    });
  }
}

export default Question
