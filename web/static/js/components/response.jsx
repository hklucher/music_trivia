import React from "react"
import ReactDOM from "react-dom"
import {RadioGroup, Radio} from "react-radio-group"

export class Response extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      selectedOption: '',
      checked: false
    };
  }

  handleCheck(e) {
    this.setState({selectedOption: e.target.value, checked: true});
  }

  render() {
    console.log(this.state.selectedOption === this.props.content)
    console.log(this.state.selectedOption);
    return (
      <label>
        <input
          type="radio"
          value={this.props.content}
          name={"response"}
          onChange={this.handleCheck.bind(this)}
          defaultChecked={this.props.content === this.state.selectedOption}/>
        {this.props.content}
      </label>
    )
  }
}
