<template>
  <v-container>
    <!-- <v-row align="center" justify="center" class="display-1 py-4">Customer Management</v-row> -->
    <v-row>
      <v-col>
        <v-card flat>
          <v-tabs fixed-tabs v-model="tabOut">
            <v-tab v-for="(opOut, idxOut) in operationsOut" :key="idxOut">{{ opOut }}</v-tab>
          </v-tabs>
          <v-tabs-items v-model="tabOut">
            <v-tab-item v-for="(opOut, idxOut) in operationsOut" :key="idxOut">
              <v-card flat>
                <v-tabs fixed-tabs v-model="tabIn">
                  <v-tab v-for="(opIn, idxIn) in operationsIn" :key="idxIn">{{ opIn }}</v-tab>
                </v-tabs>
                <v-tabs-items v-model="tabIn">
                  <v-tab-item v-for="(opIn, idxIn) in operationsIn" :key="idxIn">
                    <v-card outlined class="my-4 px-4" v-if="idxOut==0">
                      <v-card-title>{{ cardTitle[idxOut][idxIn] }}</v-card-title>
                      <v-form v-model="formCheck_0">
                        <v-row>
                          <v-col cols="4">
                            <v-text-field
                              v-model="inputDataLoan.id"
                              counter="18"
                              label="贷款 ID"
                              outlined
                              dense
                              :rules="[v => (v == '' || /^[+]{0,1}(\d+)$|^[+]{0,1}(\d+\.\d+)$/.test(v) || 'Invalid input!')]"
                            ></v-text-field>
                          </v-col>
                          <v-col cols="4">
                            <v-text-field
                              v-model="inputDataLoan.bankName"
                              counter="20"
                              label="贷款银行"
                              outlined
                              dense
                            ></v-text-field>
                          </v-col>
                        </v-row>
                        <v-row>
                          <v-col cols="3">
                            <v-text-field
                              v-model="inputDataLoan.money"
                              counter="10"
                              label="Loan Money"
                              outlined
                              :rules="[v => (v == '' || /^[+]{0,1}(\d+)$|^[+]{0,1}(\d+\.\d+)$/.test(v) || 'Invalid input!')]"
                              dense
                            ></v-text-field>
                          </v-col>
                        </v-row>
                      </v-form>
                    </v-card>
                    <v-card outlined class="my-4 px-4" v-if="idxOut==1">
                      <v-card-title>{{ cardTitle[idxOut][idxIn] }}</v-card-title>
                      <v-form v-model="formCheck_1">
                        <v-row>
                          <v-col cols="4">
                            <v-text-field
                              v-model="inputDataOwner.loanID"
                              counter="18"
                              label="贷款 ID"
                              outlined
                              dense
                              :rules="[v => (v == '' || /^[+]{0,1}(\d+)$|^[+]{0,1}(\d+\.\d+)$/.test(v) || 'Invalid input!')]"
                            ></v-text-field>
                          </v-col>
                          <v-col cols="4">
                            <v-text-field
                              v-model="inputDataOwner.customerID"
                              counter="18"
                              label="客户 ID"
                              outlined
                              dense
                              :rules="[v => (v == '' || /^[+]{0,1}(\d+)$|^[+]{0,1}(\d+\.\d+)$/.test(v) || 'Invalid input!')]"
                            ></v-text-field>
                          </v-col>
                        </v-row>
                      </v-form>
                    </v-card>
                    <v-card outlined class="my-4 px-4" v-if="idxOut==2">
                      <v-card-title>{{ cardTitle[idxOut][idxIn] }}</v-card-title>
                      <v-form v-model="formCheck_1">
                        <v-row>
                          <v-col cols="4">
                            <v-text-field
                              v-model="inputDataLoanPayment.loanID"
                              counter="18"
                              label="贷款 ID"
                              outlined
                              dense
                              :rules="[v => (v == '' || /^[+]{0,1}(\d+)$|^[+]{0,1}(\d+\.\d+)$/.test(v) || 'Invalid input!')]"
                            ></v-text-field>
                          </v-col>
                          <v-col cols="4">
                            <v-text-field
                              v-model="inputDataLoanPayment.loanPaymentID"
                              counter="18"
                              label=" 贷款号"
                              outlined
                              dense
                              :rules="[v => (v == '' || /^[+]{0,1}(\d+)$|^[+]{0,1}(\d+\.\d+)$/.test(v) || 'Invalid input!')]"
                            ></v-text-field>
                          </v-col>
                        </v-row>
                        <v-row>
                          <v-col cols="3">
                            <v-text-field
                              v-model="inputDataLoanPayment.money"
                              counter="10"
                              label="贷款支付金额"
                              outlined
                              :rules="[v => (v == '' || /^[+]{0,1}(\d+)$|^[+]{0,1}(\d+\.\d+)$/.test(v) || 'Invalid input!')]"
                              dense
                            ></v-text-field>
                          </v-col>
                        </v-row>
                        <v-row>
                          <v-col cols="3">
                            <v-menu
                              v-model="menus[idxIn]"
                              :close-on-content-click="false"
                              transition="scale-transition"
                              offset-y
                            >
                              <template v-slot:activator="{ on, attrs }">
                                <v-text-field
                                  v-model="inputDataLoanPayment.date"
                                  label="贷款支付日期"
                                  readonly
                                  outlined
                                  dense
                                  v-bind="attrs"
                                  v-on="on"
                                ></v-text-field>
                              </template>
                              <v-date-picker
                                v-model="inputDataLoanPayment.date"
                                no-title
                                @input="menus[idxIn] = false"
                              ></v-date-picker>
                            </v-menu>
                          </v-col>
                        </v-row>
                      </v-form>
                    </v-card>
                    <v-card flat class="my-4 px-4">
                      <v-row>
                        <v-col cols="2" offset="4">
                          <v-btn
                            :disabled="!commitBtnValid"
                            color="success"
                            @click="commitForm"
                          >确认</v-btn>
                        </v-col>
                        <v-col cols="2">
                          <v-btn :disabled="!resetBtnValid" color="warning" @click="resetForm">清空</v-btn>
                        </v-col>
                      </v-row>
                    </v-card>
                    <v-divider class="py-2"></v-divider>

                    <v-card
                      flat
                      v-if="idxIn!=2 && receiveData != '' && receiveData.tab_in==idxIn && receiveData.tab_out==idxOut"
                    >
                      <v-card-title>{{ cardStatusTitle[idxOut][idxIn] }}</v-card-title>
                      <v-card-text>{{ receiveData.message }}</v-card-text>
                    </v-card>
                    <v-card
                      flat
                      v-if="idxOut==0 && idxIn==2 && receiveData != '' && receiveData.tab_in==idxIn && receiveData.tab_out==idxOut"
                    >
                      <v-card-title>{{ cardStatusTitle[idxOut][idxIn] }}</v-card-title>
                      <v-simple-table>
                        <template v-slot:default>
                          <thead>
                            <tr>
                              <th class="text-left">Index</th>
                              <th class="text-left">Loan ID</th>
                              <th class="text-left">Bank Name</th>
                              <th class="text-left">Loan Money</th>
                              <th class="text-left">Loan Status</th>
                            </tr>
                          </thead>
                          <tbody>
                            <tr v-for="(ds, index) in receiveData.data" :key="index">
                              <td>{{ index }}</td>
                              <td>{{ ds.loan_id }}</td>
                              <td>{{ ds.bank_name }}</td>
                              <td>{{ ds.money }}</td>
                              <td>{{ ds.loan_status }}</td>        
                            </tr>
                          </tbody>
                        </template>
                      </v-simple-table>
                    </v-card>
                    <v-card
                      flat
                      v-if="idxOut==1 && idxIn==2 && receiveData != '' && receiveData.tab_in==idxIn && receiveData.tab_out==idxOut"
                    >
                      <v-card-title>{{ cardStatusTitle[idxOut][idxIn] }}</v-card-title>
                      <v-simple-table>
                        <template v-slot:default>
                          <thead>
                            <tr>
                              <th class="text-left">Index</th>
                              <th class="text-left">Loan ID</th>
                              <th class="text-left">Customer ID</th>
                            </tr>
                          </thead>
                          <tbody>
                            <tr v-for="(ds, index) in receiveData.data" :key="index">
                              <td>{{ index }}</td>
                              <td>{{ ds.loan_id }}</td>
                              <td>{{ ds.customer_id }}</td>     
                            </tr>
                          </tbody>
                        </template>
                      </v-simple-table>
                    </v-card>
                    <v-card
                      flat
                      v-if="idxOut==2 && idxIn==2 && receiveData != '' && receiveData.tab_in==idxIn && receiveData.tab_out==idxOut"
                    >
                      <v-card-title>{{ cardStatusTitle[idxOut][idxIn] }}</v-card-title>
                      <v-simple-table>
                        <template v-slot:default>
                          <thead>
                            <tr>
                              <th class="text-left">Index</th>
                              <th class="text-left">Loan ID</th>
                              <th class="text-left">Loan Payment ID</th>
                              <th class="text-left">Loan Payment Date</th>
                              <th class="text-left">Loan Payment Money</th>
                            </tr>
                          </thead>
                          <tbody>
                            <tr v-for="(ds, index) in receiveData.data" :key="index">
                              <td>{{ index }}</td>
                              <td>{{ ds.loan_id }}</td>
                              <td>{{ ds.loan_payment_id }}</td>
                              <td>{{ ds.loan_payment_date }}</td>
                              <td>{{ ds.money }}</td>        
                            </tr>
                          </tbody>
                        </template>
                      </v-simple-table>
                    </v-card>
                  </v-tab-item>
                </v-tabs-items>
              </v-card>
            </v-tab-item>
          </v-tabs-items>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {
  name: "LoanManage",

  data: () => ({
    menus: [false, false, false],
    receiveData: "",
    tabOut: 0,
    tabIn: 0,
    formCheck_0: null,
    formCheck_1: null,
    operationsOut: ["贷款信息", "贷款人信息", "支付情况"],
    operationsIn: ["创建", "删除", "查找"],
    cardTitle: [
      ["需要创建的贷款的信息", "需要删除的贷款的信息", "需要搜索的贷款信息"],
      [
        "需要创建的贷款所有人的信息",
        "需要删除的贷款所有人的信息",
        "需要搜索的贷款所有人信息"
      ],
      [
        "需要创建的贷款支付的信息",
        "需要删除的贷款支付的信息",
        "需要搜索的贷款支付信息"
      ]
    ],
    cardStatusTitle: [
      ["创建贷款状态", "删除贷款状态", "搜索贷款状态"],
      ["创建贷款所有人状态", "删除贷款所有人状态", "搜索贷款所有人状态"],
      ["创建贷款支付状态", "删除贷款支付状态", "搜索贷款支付状态"]
    ],
    inputDataLoan: {
      id: "",
      bankName: "",
      money: ""
    },
    inputDataLoanPayment: {
      loanID: "",
      loanPaymentID: "",
      date: "",
      money: ""
    },
    inputDataOwner: {
      loanID: "",
      customerID: ""
    }
  }),
  computed: {
    formLEmpty: function() {
      let result = this.inputDataLoan["id"].length == 0;
      for (let item in this.inputDataLoan) {
        result = result && this.inputDataLoan[item].length == 0;
      }
      return result;
    },
    formLPEmpty: function() {
      let result = this.inputDataLoanPayment["loanID"].length == 0;
      for (let item in this.inputDataLoanPayment) {
        result = result && this.inputDataLoanPayment[item].length == 0;
      }
      return result;
    },
    formLOEmpty: function() {
      let result = this.inputDataOwner["loanID"].length == 0;
      for (let item in this.inputDataOwner) {
        result = result && this.inputDataOwner[item].length == 0;
      }
      return result;
    },
    checkLCreate: function() {
      let result = true;
      for (let item in this.inputDataLoan) {
        result = result && this.inputDataLoan[item].length != 0;
      }
      return result;
    },
    checkLOreate: function() {
      let result = true;
      for (let item in this.inputDataOwner) {
        result = result && this.inputDataOwner[item].length != 0;
      }
      return result;
    },
    checkLPCreate: function() {
      let result = true;
      for (let item in this.inputDataLoanPayment) {
        result = result && this.inputDataLoanPayment[item].length != 0;
      }
      return result;
    },
    resetBtnValid: function() {
      let result = false;
      if (this.tabOut == 0) {
        result = !this.formLEmpty;
      } else if (this.tabOut == 1) {
        result = !this.formLOEmpty;
      } else {
        result = !this.formLPEmpty;
      }
      return result;
    },
    commitBtnValid: function() {
      let result = false;
      if (this.tabOut == 0) {
        if (this.tabIn == 0) {
          result = this.checkLCreate;
        } else {
          result = !this.formLEmpty;
        }
        result = result && this.formCheck_0;
      } else if (this.tabOut == 1) {
        if (this.tabIn == 0) {
          result = this.checkLOreate;
        } else {
          result = !this.formLOEmpty;
        }
      } else {
        if (this.tabIn == 0) {
          result = this.checkLPCreate;
        } else {
          result = !this.formLPEmpty;
        }
        result = result && this.formCheck_1;
      }
      return result;
    },
    postData: function() {
      return {
        tab_out: this.tabOut.toString(),
        tab_in: this.tabIn.toString(),
        loan_id:
          this.tabOut == 0
            ? this.inputDataLoan.id
            : this.tabOut == 1
            ? this.inputDataOwner.loanID
            : this.inputDataLoanPayment.loanID,
        loan_payment_id: this.inputDataLoanPayment.loanPaymentID,
        bank_name: this.inputDataLoan.bankName,
        money:
          this.tabOut == 0
            ? this.inputDataLoan.money
            : this.inputDataLoanPayment.money,
        customer_id: this.inputDataOwner.customerID,
        loan_payment_date: this.inputDataLoanPayment.date
      };
    }
  },
  methods: {
    resetForm: function() {
      if (this.tabOut == 0) {
        for (let item in this.inputDataLoan) {
          this.inputDataLoan[item] = "";
        }
      } else if (this.tabOut == 1) {
        for (let item in this.inputDataOwner) {
          this.inputDataOwner[item] = "";
        }
      } else {
        for (let item in this.inputDataLoanPayment) {
          this.inputDataLoanPayment[item] = "";
        }
      }
    },
    commitForm: function() {
      this.$axios
        .post("/loan-management", this.postData)
        .then(response => {
          this.receiveData = response.data;
        })
        .catch(function(error) {
          alert(error);
        });
    }
  }
};
</script>
