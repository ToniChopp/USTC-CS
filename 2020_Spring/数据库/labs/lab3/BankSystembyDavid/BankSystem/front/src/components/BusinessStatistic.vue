<template>
  <v-container>
    <v-card outlined class="my-4 px-4">
      <v-card-title>Please Input Information</v-card-title>
      <v-row>
        <v-col cols="2">
          <v-select
            label="业务类型"
            v-model="inputData.businessType"
            :items="['Savings', 'Loan']"
            outlined
            dense
          ></v-select>
        </v-col>
        <v-col cols="2">
          <v-select
            label="时间跨度"
            v-model="inputData.timeStep"
            :items="['Day', 'Month', 'Year']"
            outlined
            dense
          ></v-select>
        </v-col>
        <v-col cols="2">
          <v-menu
            v-model="menus[0]"
            :close-on-content-click="false"
            transition="scale-transition"
            offset-y
          >
            <template v-slot:activator="{ on, attrs }">
              <v-text-field
                v-model="inputData.startTime"
                label="起始时间"
                readonly
                outlined
                dense
                v-bind="attrs"
                v-on="on"
              ></v-text-field>
            </template>
            <v-date-picker v-model="inputData.startTime" no-title @input="menus[0] = false"></v-date-picker>
          </v-menu>
        </v-col>
        <v-col cols="2">
          <v-menu
            v-model="menus[1]"
            :close-on-content-click="false"
            transition="scale-transition"
            offset-y
          >
            <template v-slot:activator="{ on, attrs }">
              <v-text-field
                v-model="inputData.endTime"
                label="终止时间"
                readonly
                outlined
                dense
                v-bind="attrs"
                v-on="on"
              ></v-text-field>
            </template>
            <v-date-picker v-model="inputData.endTime" no-title @input="menus[1] = false"></v-date-picker>
          </v-menu>
        </v-col>
      </v-row>
    </v-card>
    <v-card flat class="my-4 px-4">
      <v-row>
        <v-col cols="2">
          <v-select
            label="图/表"
            v-model="graphType"
            :items="['Chart', 'Table']"
            outlined
            dense
          ></v-select>
        </v-col>
        <v-col cols="2" offset="2">
          <v-btn :disabled="!commitBtnValid" color="success" @click="commitForm">Commit</v-btn>
        </v-col>
        <v-col cols="2">
          <v-btn :disabled="!resetBtnValid" color="warning" @click="resetForm">Reset</v-btn>
        </v-col>
      </v-row>
    </v-card>
    <v-divider class="py-2"></v-divider>
    <v-card flat v-if="graphType == 'Table' && receiveData != ''">
      <v-card-title v-if="receiveData != ''">
       {{ receiveData.business_type }} {{ receiveData.start_time }} to {{ receiveData.end_time }}
      </v-card-title>
      <v-simple-table>
        <template v-slot:default>
          <thead>
            <tr>
              <th class="text-left">Index</th>
              <th class="text-left">Bank Name</th>
              <th class="text-left">Customers</th>
              <th class="text-left">Money</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(d, idx) in receiveData.data" :key="idx">
              <td>{{ idx }}</td>
              <td>{{ d.bank_name }}</td>
              <td>{{ d.customers }}</td>
              <td>{{ d.money }}</td>
            </tr>
          </tbody>
        </template>
      </v-simple-table>
    </v-card>
    
    <v-card flat v-if="graphType == 'Chart' && receiveData != ''">
      <v-card-title>
       {{ receiveData.business_type }} {{ receiveData.start_time }} to {{ receiveData.end_time }}
      </v-card-title>
      <ve-line :data="chartData"></ve-line>
    </v-card>
  </v-container>
</template>


<script>
export default {
  name: "BusinessStatistic",
  data: () => ({
    menus: [false, false],
    graphType: "",
    inputData: {
      businessType: "",
      timeStep: "",
      startTime: "",
      endTime: ""
    },
    receiveData: ""
  }),
  computed: {
    postData: function() {
      let result = {
        business_type: this.inputData.businessType,
        time_step: this.inputData.timeStep,
        start_time: "",
        end_time: ""
      };
      if (this.inputData.startTime != "" && this.inputData.endTime != "") {
        if (result.time_step == "Day") {
          result.start_time = this.inputData.startTime;
          result.end_time = this.inputData.endTime;
        } else if (result.time_step == "Month") {
          result.start_time = this.inputData.startTime.slice(0, -3) + "-01";
          result.end_time = this.inputData.endTime.slice(0, -3) + "-01";
        } else {
          result.start_time = this.inputData.startTime.slice(0, -6) + "-01-01";
          result.end_time = this.inputData.endTime.slice(0, -6) + "-01-01";
        }
      }
      return result;
    },
    commitBtnValid: function() {
      let result = true;
      for (let item in this.postData) {
        result = result && this.postData[item].length != 0;
      }
      result = result && this.postData.end_time > this.postData.start_time;
      return result;
    },
    resetBtnValid: function() {
      let result = true;
      for (let item in this.inputData) {
        result = result && this.inputData[item].length == 0;
      }
      return !result;
    },
    chartData: function () {
      let result = {
        columns: ['bank_name', 'customers', 'money'],
        rows: []
      }
      if (this.receiveData != '') {
        result.rows = this.receiveData.data
      }
      return result
    }
  },
  methods: {
    commitForm: function() {
      this.$axios
        .post("/business-statistic", this.postData)
        .then((response) => {
          this.receiveData = response.data
        })
        .catch(function(error) {
          alert(error)
        });
    },
    resetForm: function() {
      for (let item in this.inputData) {
        this.inputData[item] = "";
      }
    }
  }
};
</script>
