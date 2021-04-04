<template>
  <div id="app">
    <div id="HeaderLayer">
      <data-input v-bind:begin="begin" @ChangHour="HandleHour" @ChangeMinute="HandleMinute"
      @ChangeSecond="HandleSecond"></data-input>
      <buttons-display v-bind:begin="begin" v-bind:CountUp="CountUp" v-bind:CountDown="CountDown"
      v-bind:Clear="Clear" v-bind:Restart="Restart" v-bind:end="end" v-bind:paused="paused"
      v-bind:up="up" v-bind:down="down" @NowPause="UpdatePause" @NowResume="UpdatePause"></buttons-display>
      <hint-display v-bind:begin="begin" v-bind:hint="hint"></hint-display>
    </div>
    <number-display v-bind:msg="msg"></number-display>
  </div>
</template>

<script>
import DataInput from './components/DataInput'
import ButtonsDisplay from './components/ButtonsDisplay'
import HintDisplay from './components/HintDisplay'
import NumberDisplay from './components/NumberDisplay'
export default {
  name: 'App',
  components: {
    DataInput,
    ButtonsDisplay,
    HintDisplay,
    NumberDisplay
  },
  data: function () {
    return {
      begin: true,
      end: false,
      paused: false,
      up: false,
      down: false,
      cleared: false,
      innerTime: 0,
      settledTime: 0,
      startTime: 0,
      msg: '00:00:00'
    }
  },
  methods: {
    HandleHour: function (val) {
      this.hour = val
    },

    HandleMinute: function (val) {
      this.minute = val
    },

    HandleSecond: function (val) {
      this.second = val
    },

    DisplayNumber: function (hour, minute, second) {
      let showmsg = ''
      if (hour < 10) {
        showmsg += '0' + hour.toString()
      } else {
        showmsg += hour.toString()
      }
      showmsg += ':'
      if (minute < 10) {
        showmsg += '0' + minute.toString()
      } else {
        showmsg += minute.toString()
      }
      showmsg += ':'
      if (second < 10) {
        showmsg += '0' + second.toString()
      } else {
        showmsg += second.toString()
      }
      return showmsg
    },

    UpdatePause: function (data) {
      this.paused = data.paused
      if (this.paused) {
        this.pauseTime = new Date().getTime()
        if (this.up) {
          this.hint = '暂停正计时 ' + this.DisplayNumber(this.hour, this.minute, this.second)
        }
        if (this.down) {
          this.hint = '暂停倒计时 ' + this.DisplayNumber(this.hour, this.minute, this.second)
        }
      } else {
        this.resumeTime = new Date().getTime()
        this.startTime = this.startTime + this.resumeTime - this.pauseTime
        if (this.up) {
          this.hint = '正在正计时 ' + this.DisplayNumber(this.hour, this.minute, this.second)
        }
        if (this.down) {
          this.hint = '正在倒计时 ' + this.DisplayNumber(this.hour, this.minute, this.second)
        }
      }
    },

    CountUp: function () {
      let hintmsg
      if ((isNaN(this.hour)) || (this.hour < 0)) {
        this.hour = 0
      }
      if (this.hour > 99) {
        this.hour = 99
      }
      if ((isNaN(this.minute)) || (this.minute < 0)) {
        this.minute = 0
      }
      if (this.minute > 59) {
        this.minute = 59
      }
      if ((isNaN(this.second)) || (this.second < 0)) {
        this.second = 0
      }
      if (this.second > 59) {
        this.second = 59
      }
      this.startTime = new Date().getTime()
      this.innerTime = 0
      this.settledTime = this.hour * 3600 * 10 + this.minute * 60 * 10 + this.second * 10
      this.begin = false
      this.end = false
      this.up = true
      this.down = false
      this.paused = false
      this.cleared = false
      hintmsg = this.DisplayNumber(this.hour, this.minute, this.second)
      this.hint = '正在正计时 ' + hintmsg
      setTimeout(this.CountUpCall, 100)
    },

    CountUpCall: function () {
      if (!this.paused) {
        this.innerTime++
      }
      let hour = Math.floor(this.innerTime / (3600 * 10))
      let minute = Math.floor(this.innerTime / (60 * 10)) % 60
      let second = Math.floor(this.innerTime / 10) % 60
      let offsite = new Date().getTime() - (this.startTime + (this.innerTime - 1) * 100)
      let nextTime = 100 - offsite
      if (this.innerTime >= this.settledTime) {
        this.cleared = false
        this.end = true
        this.msg = this.DisplayNumber(hour, minute, second)
        this.hint = '正计时 ' + this.msg + ' 已结束'
      } else if (!this.cleared) {
        this.msg = this.DisplayNumber(hour, minute, second)
        setTimeout(this.CountUpCall, nextTime)
      }
    },

    CountDown: function () {
      let hintmsg
      if ((isNaN(this.hour)) || (this.hour < 0)) {
        this.hour = 0
      }
      if (this.hour > 99) {
        this.hour = 99
      }
      if ((isNaN(this.minute)) || (this.minute < 0)) {
        this.minute = 0
      }
      if (this.minute > 59) {
        this.minute = 59
      }
      if ((isNaN(this.second)) || (this.second < 0)) {
        this.second = 0
      }
      if (this.second > 59) {
        this.second = 59
      }
      this.startTime = new Date().getTime()
      this.innerTime = 0
      this.settledTime = this.hour * 3600 * 10 + this.minute * 60 * 10 + this.second * 10
      if (this.settledTime === 0) {
        this.begin = false
        this.end = true
        this.up = false
        this.down = true
        this.paused = false
        this.cleared = false
        hintmsg = this.DisplayNumber(0, 0, 0)
        this.hint = '倒计时' + hintmsg + '已结束'
      } else {
        this.begin = false
        this.end = false
        this.up = false
        this.down = true
        this.paused = false
        this.cleared = false
        hintmsg = this.DisplayNumber(this.hour, this.minute, this.second)
        this.hint = '正在倒计时 ' + hintmsg
        setTimeout(this.CountDownCall, 100)
      }
    },

    CountDownCall: function () {
      if (!this.paused) {
        this.innerTime++
      }
      let hour = Math.floor((this.settledTime - this.innerTime) / (3600 * 10))
      let minute = Math.floor((this.settledTime - this.innerTime) / (60 * 10)) % 60
      let second = Math.floor((this.settledTime - this.innerTime) / 10) % 60
      let offsite = new Date().getTime() - (this.startTime + (this.innerTime - 1) * 100)
      let nextTime = 100 - offsite
      if (this.innerTime >= this.settledTime) {
        this.cleared = false
        this.end = true
        this.msg = this.DisplayNumber(hour, minute, second)
        this.hint = '倒计时 ' + this.msg + ' 已结束'
      } else if (!this.cleared) {
        this.msg = this.DisplayNumber(hour, minute, second)
        setTimeout(this.CountDownCall, nextTime)
      }
    },

    Clear: function () {
      this.cleared = true
      this.begin = true
      this.end = false
      this.up = false
      this.down = false
      this.paused = false
      this.msg = '00:00:00'
    },

    Restart: function () {
      if (this.up) {
        this.CountUp()
      } else if (this.down) {
        this.CountDown()
      }
    },

    judgeenter: function () {
      if (this.begin) {
        this.CountUp()
      }
    },

    judgespace: function () {
      if (!this.begin && !this.end) {
        this.UpdateState()
      }
    },

    UpdateState: function () {
      this.paused = ~this.paused
      if (this.paused) {
        this.pauseTime = new Date().getTime()
        if (this.up) {
          this.hint = '暂停正计时 ' + this.DisplayNumber(this.hour, this.minute, this.second)
        } else if (this.down) {
          this.hint = '暂停倒计时 ' + this.DisplayNumber(this.hour, this.minute, this.second)
        }
      } else {
        this.resumeTime = new Date().getTime()
        this.startTime = this.startTime + this.resumeTime - this.pauseTime
        if (this.up) {
          this.hint = '正在正计时 ' + this.DisplayNumber(this.hour, this.minute, this.second)
        } else if (this.down) {
          this.hint = '正在倒计时 ' + this.DisplayNumber(this.hour, this.minute, this.second)
        }
      }
    },

    Handlekeyup (event) {
      const e = event || window.event
      if (!e) return
      const {key, keyCode} = e
      if (keyCode === 13) {
        this.judgeenter()
      } else if (keyCode === 32) {
        this.judgespace()
      }
      return key
    }
  },
  mounted () {
    window.addEventListener('keyup', this.Handlekeyup)
  }
}
</script>

<style>
*{
  margin: 0;
  padding: 0;
}
#app {
  margin: 0;
  padding: 0;
  width: 1220px;
  height: 510px;
  background-color: #F2F4F7;
  box-shadow: 0px 2px 4px 0px rgba(0,0,0,0.10);
}
#HeaderLayer{
  width: 1220px;
  height: 70px;
  background-color: #97A5BC;
  box-shadow: 0px 2px 4px 0px rgba(0,0,0,0.10);
}
</style>
