import React from "react"
import ReactDom from "react-dom"
import {ResponsesBox} from "./responses_box"

export class Question extends React.Component {
  constructor(props) {
    super();
    this.state = {
      answer: '',
      selectedValue: '',
      currentlyCorrect: false
    };
  }

  render() {
    return (
      <div>
        <p className="sans-serif">{this.props.content}</p>
        <ResponsesBox
          responses={this.props.responses}
          handleChange={this.handleChange.bind(this)}>
        </ResponsesBox>
        <button onClick={this.handleSubmit.bind(this)}>Submit</button>
      </div>
    )
  }

  _correctAnswer() {
    for (var i = 0; i < this.props.responses.length; i ++) {
      if (this.props.responses[i].correct) {
        return this.props.responses[i];
      }
    }
  }

  handleChange(value) {
    this.setState({selectedValue: value});
    if (value === this._correctAnswer().content) {
      this.setState({currentlyCorrect: true});
    } else {
      this.setState({currentlyCorrect: false});
    }
  }

  handleSubmit() {
    if (this.state.selectedValue === '') {
      return;
    } else {
      this.props.handleSubmit(this.state.currentlyCorrect, this.state.selectedValue);
      this.setState({selectedValue: ''});
    }
  }
}
