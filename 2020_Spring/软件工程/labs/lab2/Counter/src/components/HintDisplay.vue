<template>
  <div id="hint" v-if="!begin">
    {{hint}}
  </div>
</template>
<script>
export default {
  name: 'HintDisplay',
  props: {
    hint: String,
    begin: Boolean
  }
}
</script>
<style>
#hint{
  margin: 0;
  border: 0;
  position: absolute;
  left: 40px;
  top: 24px;
  width: 192px;
  height: 22px;
  font-family: PTMono-Regular, "PT Mono", PingFangSC-Regular, "PingFang SC", sans-serif;
  color: #FFFFFF;
  font-size: 16px;
}
</style>
