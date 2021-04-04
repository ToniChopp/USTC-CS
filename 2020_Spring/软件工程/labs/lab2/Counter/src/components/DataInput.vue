<template>
  <div id="DataInput" v-if='begin'>
    <input placeholder="0" type="text" id="hour" min="0" max="99" v-model="hour" @change="ChangeHour()">
    <label id="hourDisplay">时</label>
    <input placeholder="0" type="text" id="minute" min="0" max="59" v-model="minute" @change="ChangeMinute()">
    <label id="minuteDisplay">分</label>
    <input placeholder="0" type="text" id="second" min="0" max="99" v-model="second" @change="ChangeSecond()">
    <label id="secondDisplay">秒</label>
  </div>
</template>
<script>
export default {
  name: 'DataInput',
  props: {
    begin: Boolean,
    hour: Number,
    minute: Number,
    second: Number
  },
  methods: {
    ChangeHour: function () {
      this.$emit('ChangeHour', this.hour)
    },
    ChangeMinute: function () {
      this.$emit('ChangeMinute', this.minute)
    },
    ChangeSecond: function () {
      this.$emit('ChangeSecond', this.second)
    }
  }
}
</script>
<style>
input{
  margin: 0;
  border: 0;
  position: absolute;
  top: 15px;
  width: 70px;
  height: 40px;
  background-color: #ffffff;
  box-shadow: 0px 2px 4px 0px rgba(0,0,0,0.10);
  border-radius: 5px;
}
#hour{
  left: 40px;
}
#minute{
  left: 130px;
}
#second{
  left: 220px;
}
input::placeholder{
  color: #AFAFAF;
  font-family: PingFangSC-Regular;
  position: relative;
  left: 9px;
  height: 24px;
  font-size: 16px;
}
label{
    margin: 0;
    border: 0;
    position: absolute;
    top: 24px;
    width: 32px;
    height: 22px;
    text-align: right;
    font-family: PingFangSC-Regular, "PingFang SC", sans-serif;
    color: #222222;
}
#hourDisplay{
  left: 69px;
}
#minuteDisplay{
  left: 159px;
}
#secondDisplay{
  left: 249px;
}
</style>
