<template>
  <div id="ButtonsDisplay">
    <button type="button" id="countup" v-if="begin" @click="CountUp">开始正计时</button>
    <button type="button" id="countdown" v-if="begin" @click="CountDown">开始倒计时</button>
    <button type="button" id="clear" v-if="up&&!begin" @click="Clear">清空正计时</button>
    <button type="button" id="clear" v-if="down&&!begin" @click="Clear">清空倒计时</button>
    <button type="button" id="restart" v-if="!begin" @click="Restart">重新再计时</button>
    <button type="button" id="pause" v-if="!begin&&!paused&&!end"  @click="Pause()">暂停计时器</button>
    <button type="button" id="resume" v-else-if="!begin&&!end" @click="Resume()">恢复计时器</button>
  </div>
</template>
<script>
export default {
  name: 'ButtonsDisplay',
  props: {
    begin: Boolean,
    end: Boolean,
    paused: Boolean,
    up: Boolean,
    down: Boolean,
    CountUp: Function,
    CountDown: Function,
    Clear: Function,
    Restart: Function
  },
  methods: {
    Pause () {
      let data = {
        paused: true
      }
      this.$emit('NowPause', data)
    },
    Resume () {
      let data = {
        paused: false
      }
      this.$emit('NowResume', data)
    }
  }
}
</script>
<style>
button{
  margin: 0;
  border: 0;
  position: absolute;
  top: 15px;
  width: 98px;
  height: 40px;
  box-shadow: 0px 2px 4px 0px rgba(0,0,0,0.10);
  border-radius: 5px;
  padding-top: 9px;
  padding-left: 9px;
  padding-right: 9px;
  padding-bottom: 9px;
  font-size: 16px;
  color: #ffffff;
  font-family: PingFangSC-Regular, "PingFang SC", sans-serif;
}
#countup{
  left: 310px;
  background: #2188E9;
}
#countdown{
  left: 428px;
  background: #2188E9;
}
#pause{
  left: 227px;
  background: #2188E9;
}
#resume{
  left: 227px;
  background: #2188E9;
}
#clear{
  left: 964px;
  background: #DD2E1D;
}
#restart{
  left: 1082px;
  background: #FFB020;
}
</style>
