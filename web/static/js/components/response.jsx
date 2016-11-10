import React from "react"
import ReactDOM from "react-dom"

export class Response extends React.Component {
  constructor(props) {
    super(props);
    this.state = {};
  }

  render() {
    return (
      <label>
        <input type="radio" value={this.props.content} name="response"/>
        {this.props.content}
      </label>
    )
  }
}
