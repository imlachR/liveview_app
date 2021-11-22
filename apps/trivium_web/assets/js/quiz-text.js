const QuizText = {
  mounted() {
    this.el.addEventListener('focusout', (e)  => {
      this.pushEvent("update-quiz-text", {quiz_text: this.el.innerText, id: this.el.dataset.quizId});
    });
  }
}

export default QuizText
