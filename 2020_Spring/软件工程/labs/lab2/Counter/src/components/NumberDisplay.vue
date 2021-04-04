<template>
  <div id="NumberDisplay">
    <div id="time">
      {{msg}}
    </div>
  </div>
</template>
<script>
export default {
  name: 'NumberDisplay',
  props: {
    msg: String
  }
}
</script>
<style>
#display{
  margin: 0;
  border: 0;
  width: 1140px;
  height: 440px;
  position: absolute;
  top: 70px;
  left: 40px;
}
#time{
  margin: 0;
  border: 0;
  position: absolute;
  left: 131px;
  top: 197px;
  width: 960px;
  height: 200px;
  font-family: PTMono-Bold, "PT Mono", monospace;
  font-weight: 700;
  color: #333333;
  font-size: 200px;
  letter-spacing: 0;
  line-height: 200px;
}
</style>
