import React from "react"
import ReactDOM from "react-dom"

export class QuestionList extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    console.log(this.props.questions);
    const _this = this;
    let questionList = this.props.questions.map(function(quest, index) {
      return (
        <div key={quest.id}>
          <h3>Question {index + 1}</h3>
          <ul>
            {_this._mapResponses(quest)}
          </ul>
        </div>
      )
    });
    return (
      <div>
        {questionList}
      </div>
    )
  }

  _mapResponses(question) {
    let responseList = question.responses.map(function(resp) {
      return (
        <li key={resp.id}>{resp.content}</li>
      )
    });
    return responseList;
  }
}


QuestionList.propTypes = {
  questions: React.PropTypes.array
}
