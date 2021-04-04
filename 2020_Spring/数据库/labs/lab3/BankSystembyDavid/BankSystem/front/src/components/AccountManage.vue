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
                      <v-card-title>{{ cardOneTitle[idxOut][idxIn] }}</v-card-title>
                      <v-form v-model="formCheck_0">
                        <v-row>
                          <v-col cols="4">
                            <v-text-field
                              v-model="inputDataAccount.id"
                              counter="18"
                              label="ID"
                              outlined
                              dense
                              :rules="[v => (v == '' || /^[+]{0,1}(\d+)$|^[+]{0,1}(\d+\.\d+)$/.test(v) || 'Invalid input!')]"
                            ></v-text-field>
                          </v-col>
                          <v-col cols="4">
                            <v-text-field
                              v-model="inputDataAccount.balance"
                              counter="10"
                              label="余额"
                              outlined
                              dense
                              :rules="[v => (v == '' || /^[+]{0,1}(\d+)$|^[+]{0,1}(\d+\.\d+)$/.test(v) || 'Invalid input!')]"
                            ></v-text-field>
                          </v-col>
                          <v-col cols="4">
                            <v-text-field
                              v-model="inputDataAccount.openBank"
                              counter="20"
                              label="开户银行"
                              outlined
                              dense
                            ></v-text-field>
                          </v-col>
                        </v-row>
                        <v-row>
                          <v-col cols="4">
                            <v-menu
                              v-model="tabMenu[idxIn].menu1"
                              :close-on-content-click="false"
                              transition="scale-transition"
                              offset-y
                            >
                              <template v-slot:activator="{ on, attrs }">
                                <v-text-field
                                  v-model="inputDataAccount.openDate"
                                  label="开户日期"
                                  outlined
                                  dense
                                  readonly
                                  v-bind="attrs"
                                  v-on="on"
                                ></v-text-field>
                              </template>
                              <v-date-picker
                                v-model="inputDataAccount.openDate"
                                no-title
                                @input="tabMenu[idxIn].menu1 = false"
                              ></v-date-picker>
                            </v-menu>
                          </v-col>
                          <v-col cols="3">
                            <v-select
                              label="账户类型"
                              v-model="inputDataAccount.type"
                              :items="['Checking', 'Savings']"
                              outlined
                              dense
                            ></v-select>
                          </v-col>
                        </v-row>
                        <v-row>
                          <v-col cols="3" v-if="inputDataAccount.type == 'Checking'">
                            <v-text-field
                              v-model="inputDataAccount.CheckingAccountCredit"
                              counter="10"
                              label="贷款金额"
                              outlined
                              dense
                              :rules="[v => (v == '' || /^[+]{0,1}(\d+)$|^[+]{0,1}(\d+\.\d+)$/.test(v) || 'Invalid input!')]"
                            ></v-text-field>
                          </v-col>
                          <v-col cols="2" v-if="inputDataAccount.type == 'Savings'">
                            <v-text-field
                              v-model="inputDataAccount.savingsAccountRate"
                              counter="5"
                              label="利率"
                              outlined
                              dense
                              :rules="[v => (v == '' || /^[+]{0,1}(\d+)$|^[+]{0,1}(\d+\.\d+)$/.test(v) || 'Invalid input!')]"
                            ></v-text-field>
                          </v-col>
                          <v-col cols="2" v-if="inputDataAccount.type == 'Savings'">
                            <v-text-field
                              v-model="inputDataAccount.savingsAccountCurrencyType"
                              counter="5"
                              label="币种"
                              outlined
                              dense
                            ></v-text-field>
                          </v-col>
                        </v-row>
                      </v-form>
                    </v-card>
                    <v-card outlined class="my-4 px-4" v-if="idxOut==0 && idxIn==2">
                      <v-card-title>更新后的账户信息</v-card-title>
                      <v-form v-model="formCheck_1">
                        <v-row>
                          <v-col cols="4">
                            <v-text-field
                              v-model="modifyDataAccount.id"
                              counter="18"
                              label="ID"
                              outlined
                              disabled
                              dense
                              :rules="[v => (v == '' || /^[+]{0,1}(\d+)$|^[+]{0,1}(\d+\.\d+)$/.test(v) || 'Invalid input!')]"
                            ></v-text-field>
                          </v-col>
                          <v-col cols="4">
                            <v-text-field
                              v-model="modifyDataAccount.balance"
                              counter="10"
                              label="余额"
                              outlined
                              dense
                              :rules="[v => (v == '' || /^[+]{0,1}(\d+)$|^[+]{0,1}(\d+\.\d+)$/.test(v) || 'Invalid input!')]"
                            ></v-text-field>
                          </v-col>
                          <v-col cols="4">
                            <v-text-field
                              v-model="modifyDataAccount.openBank"
                              counter="20"
                              label="开户银行"
                              outlined
                              disabled
                              dense
                            ></v-text-field>
                          </v-col>
                        </v-row>
                        <v-row>
                          <v-col cols="4">
                            <v-menu
                              v-model="tabMenu[idxIn].menu2"
                              :close-on-content-click="false"
                              transition="scale-transition"
                              offset-y
                            >
                              <template v-slot:activator="{ on, attrs }">
                                <v-text-field
                                  v-model="modifyDataAccount.openDate"
                                  label="开户日期"
                                  outlined
                                  dense
                                  readonly
                                  v-bind="attrs"
                                  v-on="on"
                                  disabled
                                ></v-text-field>
                              </template>
                              <v-date-picker
                                v-model="modifyDataAccount.openDate"
                                no-title
                                disabled
                                @input="tabMenu[idxIn].menu2 = false"
                              ></v-date-picker>
                            </v-menu>
                          </v-col>
                          <v-col cols="2">
                            <v-select
                              label="账户类型"
                              v-model="modifyDataAccount.type"
                              :items="['Checking', 'Savings']"
                              outlined
                              disabled
                              dense
                            ></v-select>
                          </v-col>
                        </v-row>
                        <v-row>
                          <v-col cols="3" v-if="inputDataAccount.type == 'Checking'">
                            <v-text-field
                              v-model="modifyDataAccount.CheckingAccountCredit"
                              counter="10"
                              label="贷款金额"
                              outlined
                              dense
                              :rules="[v => (v == '' || /^[+]{0,1}(\d+)$|^[+]{0,1}(\d+\.\d+)$/.test(v) || 'Invalid input!')]"
                            ></v-text-field>
                          </v-col>
                          <v-col cols="2" v-if="inputDataAccount.type == 'Savings'">
                            <v-text-field
                              v-model="modifyDataAccount.savingsAccountRate"
                              counter="5"
                              label="利率"
                              outlined
                              dense
                              :rules="[v => (v == '' || /^[+]{0,1}(\d+)$|^[+]{0,1}(\d+\.\d+)$/.test(v) || 'Invalid input!')]"
                            ></v-text-field>
                          </v-col>
                          <v-col cols="2" v-if="inputDataAccount.type == 'Savings'">
                            <v-text-field
                              v-model="modifyDataAccount.savingsAccountCurrencyType"
                              counter="5"
                              label="币种"
                              outlined
                              dense
                            ></v-text-field>
                          </v-col>
                        </v-row>
                      </v-form>
                    </v-card>
                    <v-card outlined class="my-4 px-4" v-if="idxOut==1">
                      <v-card-title>{{ cardOneTitle[idxOut][idxIn] }}</v-card-title>
                      <v-form v-model="formCheck_2">
                        <v-row>
                          <v-col cols="4">
                            <v-text-field
                              v-model="inputDataOwner.id"
                              counter="18"
                              label="账户 ID"
                              outlined
                              dense
                            ></v-text-field>
                          </v-col>
                          <v-col cols="4">
                            <v-text-field
                              v-model="inputDataOwner.customerID"
                              counter="18"
                              label="客户 ID"
                              outlined
                              dense
                            ></v-text-field>
                          </v-col>
                        </v-row>
                        <v-row>
                          <v-col cols="3">
                            <v-text-field
                              v-model="inputDataOwner.openBank"
                              counter="20"
                              label="开户银行"
                              outlined
                              dense
                            ></v-text-field>
                          </v-col>
                          <v-col cols="4">
                            <v-menu
                              v-model="tabMenu2[idxIn].menu1"
                              :close-on-content-click="false"
                              transition="scale-transition"
                              offset-y
                            >
                              <template v-slot:activator="{ on, attrs }">
                                <v-text-field
                                  v-model="inputDataOwner.lastVisitDate"
                                  label="最近访问日期"
                                  outlined
                                  dense
                                  readonly
                                  v-bind="attrs"
                                  v-on="on"
                                ></v-text-field>
                              </template>
                              <v-date-picker
                                v-model="inputDataOwner.lastVisitDate"
                                no-title
                                @input="tabMenu2[idxIn].menu1 = false"
                              ></v-date-picker>
                            </v-menu>
                          </v-col>
                          <v-col cols="3">
                            <v-select
                              label="账户类型"
                              v-model="inputDataOwner.type"
                              :items="['Checking', 'Savings']"
                              outlined
                              dense
                            ></v-select>
                          </v-col>
                        </v-row>
                      </v-form>
                    </v-card>
                    <v-card outlined class="my-4 px-4" v-if="idxOut==1 && idxIn==2">
                      <v-card-title>{{ cardOneTitle[idxOut][idxIn] }}</v-card-title>
                      <v-form v-model="formCheck_3">
                        <v-row>
                          <v-col cols="4">
                            <v-text-field
                              v-model="modifyDataOwner.id"
                              counter="18"
                              label="账户 ID"
                              outlined
                              disabled
                              dense
                              :rules="[v => (v == '' || /^[+]{0,1}(\d+)$|^[+]{0,1}(\d+\.\d+)$/.test(v) || 'Invalid input!')]"
                            ></v-text-field>
                          </v-col>
                          <v-col cols="4">
                            <v-text-field
                              v-model="modifyDataOwner.customerID"
                              counter="18"
                              label="客户 ID"
                              outlined
                              disabled
                              dense
                              :rules="[v => (v == '' || /^[+]{0,1}(\d+)$|^[+]{0,1}(\d+\.\d+)$/.test(v) || 'Invalid input!')]"
                            ></v-text-field>
                          </v-col>
                        </v-row>
                        <v-row>
                          <v-col cols="3">
                            <v-text-field
                              v-model="modifyDataOwner.openBank"
                              counter="20"
                              label="开户银行"
                              outlined
                              disabled
                              dense
                            ></v-text-field>
                          </v-col>
                          <v-col cols="4">
                            <v-menu
                              v-model="tabMenu2[idxIn].menu2"
                              :close-on-content-click="false"
                              transition="scale-transition"
                              offset-y
                            >
                              <template v-slot:activator="{ on, attrs }">
                                <v-text-field
                                  v-model="modifyDataOwner.lastVisitDate"
                                  label="最近访问日期"
                                  outlined
                                  dense
                                  readonly
                                  v-bind="attrs"
                                  v-on="on"
                                ></v-text-field>
                              </template>
                              <v-date-picker
                                v-model="modifyDataOwner.lastVisitDate"
                                no-title
                                @input="tabMenu2[idxIn].menu2 = false"
                              ></v-date-picker>
                            </v-menu>
                          </v-col>
                          <v-col cols="3">
                            <v-select
                              label="账户类型"
                              v-model="modifyDataOwner.type"
                              :items="['Checking', 'Savings']"
                              outlined
                              disabled
                              dense
                            ></v-select>
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
                      v-if="idxIn!=3 && receiveData != '' && receiveData.tab_in==idxIn && receiveData.tab_out==idxOut"
                    >
                      <v-card-title>{{ cardStatusTitle[idxOut][idxIn] }}</v-card-title>
                      <v-card-text>{{ receiveData.message }}</v-card-text>
                    </v-card>

                    <v-card
                      flat
                      v-if="idxOut==0 && idxIn==3 && receiveData != '' && receiveData.tab_in==idxIn && receiveData.tab_out==idxOut"
                    >
                      <v-card-title>{{ cardStatusTitle[idxOut][idxIn] }}</v-card-title>
                      <v-card-text>{{ receiveData.message }}</v-card-text>

                      <v-simple-table>
                        <template v-slot:default>
                          <thead>
                            <tr>
                              <th class="text-left">Index</th>
                              <th class="text-left">Account ID</th>
                              <th class="text-left">Account Type</th>
                              <th class="text-left">Account Balance</th>
                              <th class="text-left">Account Open Bank</th>
                              <th class="text-left">Account Open Date</th>
                              <th class="text-left">Account Credit</th>
                              <th class="text-left">Account Currency Type</th>
                              <th class="text-left">Account Rate</th>
                            </tr>
                          </thead>
                          <tbody>
                            <tr v-for="(ds, index) in receiveData.data" :key="index">
                              <td>{{ index }}</td>
                              <td>{{ ds.account_id }}</td>
                              <td>{{ ds.account_type }}</td>
                              <td>{{ ds.account_balance }}</td>
                              <td>{{ ds.account_open_bank }}</td>
                              <td>{{ ds.account_open_date }}</td>
                              <td>{{ ds.account_credit }}</td>
                              <td>{{ ds.account_currency_type }}</td>
                              <td>{{ ds.account_rate }}</td>
                            </tr>
                          </tbody>
                        </template>
                      </v-simple-table>
                    </v-card>
                    <v-card
                      flat
                      v-if="idxOut==1 && idxIn==3 && receiveData != '' && receiveData.tab_in==idxIn && receiveData.tab_out==idxOut"
                    >
                      <v-card-title>{{ cardStatusTitle[idxOut][idxIn] }}</v-card-title>
                      <v-card-text>{{ receiveData.message }}</v-card-text>

                      <v-simple-table>
                        <template v-slot:default>
                          <thead>
                            <tr>
                              <th class="text-left">Index</th>
                              <th class="text-left">Account ID</th>
                              <th class="text-left">Account Type</th>
                              <th class="text-left">Customer ID</th>
                              <th class="text-left">Account Open Bank</th>
                              <th class="text-left">Account Last Visit Date</th>
                            </tr>
                          </thead>
                          <tbody>
                            <tr v-for="(ds, index) in receiveData.data" :key="index">
                              <td>{{ index }}</td>
                              <td>{{ ds.account_id }}</td>
                              <td>{{ ds.account_type }}</td>
                              <td>{{ ds.customer_id }}</td>
                              <td>{{ ds.account_open_bank }}</td>
                              <td>{{ ds.account_last_visit_date }}</td>
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
  name: "AccountManage",

  data: () => ({
    tabMenu: [
      {
        menu1: false,
        menu2: false
      },
      {
        menu1: false,
        menu2: false
      },
      {
        menu1: false,
        menu2: false
      },
      {
        menu1: false,
        menu2: false
      }
    ],
    tabMenu2: [
      {
        menu1: false,
        menu2: false
      },
      {
        menu1: false,
        menu2: false
      },
      {
        menu1: false,
        menu2: false
      },
      {
        menu1: false,
        menu2: false
      }
    ],
    tabOut: 0,
    tabIn: 0,
    formCheck_0: null,
    formCheck_1: null,
    formCheck_2: null,
    formCheck_3: null,
    operationsOut: ["账户管理", "账户所有人管理"],
    operationsIn: ["创建", "删除", "更改", "查找"],
    cardOneTitle: [
      [
        "需要创建的账户的信息",
        "需要删除的账户的信息",
        "更新前的账户信息",
        "需要搜索的账户信息"
      ],
      [
        "需要创建的所有者的信息",
        "需要删除的所有者的信息",
        "更新前的所有者信息",
        "需要搜索的所有者信息"
      ]
    ],
    cardStatusTitle: [
      ["创建账户结果", "删除账户结果", "更新账户结果", "搜索账户结果"],
      ["创建所有者结果", "删除所有者结果", "更新所有者结果", "搜索所有者结果"]
    ],
    inputDataAccount: {
      id: "",
      balance: "",
      openDate: "",
      type: "",
      openBank: "",
      CheckingAccountCredit: "",
      savingsAccountRate: "",
      savingsAccountCurrencyType: ""
    },
    modifyDataAccount: {
      id: "",
      balance: "",
      openDate: "",
      type: "",
      openBank: "",
      CheckingAccountCredit: "",
      savingsAccountRate: "",
      savingsAccountCurrencyType: ""
    },
    inputDataOwner: {
      id: "",
      type: "",
      openBank: "",
      customerID: "",
      lastVisitDate: ""
    },
    modifyDataOwner: {
      id: "",
      type: "",
      openBank: "",
      customerID: "",
      lastVisitDate: ""
    },
    receiveData: ""
  }),
  computed: {
    formInputDataAccountEmpty: function() {
      let result = this.inputDataAccount["id"].length == 0;
      for (let item in this.inputDataAccount) {
        result = result && this.inputDataAccount[item].length == 0;
      }
      return result;
    },
    formModifyDataAccountEmpty: function() {
      let result = this.modifyDataAccount["id"].length == 0;
      for (let item in this.modifyDataAccount) {
        result = result && this.modifyDataAccount[item].length == 0;
      }
      return result;
    },
    formInputDataOwnerEmpty: function() {
      let result = this.inputDataOwner["id"].length == 0;
      for (let item in this.inputDataOwner) {
        result = result && this.inputDataOwner[item].length == 0;
      }
      return result;
    },
    formModifyDataOwnerEmpty: function() {
      let result = this.modifyDataOwner["id"].length == 0;
      for (let item in this.modifyDataOwner) {
        result = result && this.modifyDataOwner[item].length == 0;
      }
      return result;
    },
    checkAccountCreate: function() {
      let result = true;
      if (this.inputDataAccount.type == "Checking") {
        for (let item in this.inputDataAccount) {
          if (
            item == "savingsAccountRate" ||
            item == "savingsAccountCurrencyType"
          ) {
            continue;
          }
          result = result && this.inputDataAccount[item] != "";
        }
      } else if (this.inputDataAccount.type == "Savings") {
        for (let item in this.inputDataAccount) {
          if (item == "CheckingAccountCredit") {
            continue;
          }
          result = result && this.inputDataAccount[item] != "";
        }
      } else {
        result = false;
      }
      return result;
    },
    checkOwnerCreate: function() {
      let result = true;
      for (let item in this.inputDataOwner) {
        result = result && this.inputDataOwner[item] != 0;
      }
      return result;
    },
    resetBtnValid: function() {
      let result = false;
      if (this.tabOut == 0) {
        if (this.tabIn == 2) {
          // if modify
          result =
            !this.formInputDataAccountEmpty || !this.formModifyDataAccountEmpty;
        } else {
          result = !this.formInputDataAccountEmpty;
        }
      } else {
        if (this.tabIn == 2) {
          // if modify
          result =
            !this.formInputDataOwnerEmpty || !this.formModifyDataOwnerEmpty;
        } else {
          result = !this.formInputDataOwnerEmpty;
        }
      }
      return result;
    },
    commitBtnValid: function() {
      let result = false;
      if (this.tabOut == 0) {
        if (this.tabIn == 0) {
          // if modify
          result = this.checkAccountCreate && this.formCheck_0;
        } else if (this.tabIn == 1) {
          result =
            !this.formInputDataAccountEmpty &&
            this.inputDataAccount.type != "" &&
            this.formCheck_0;
        } else if (this.tabIn == 2) {
          result =
            !this.formInputDataAccountEmpty &&
            !this.formModifyDataAccountEmpty &&
            this.inputDataAccount.type != "" &&
            this.formCheck_0 &&
            this.formCheck_1;
        } else {
          result =
            !this.formInputDataAccountEmpty &&
            this.inputDataAccount.type != "" &&
            this.formCheck_0;
        }
      } else {
        if (this.tabIn == 0) {
          // if modify
          result = this.checkOwnerCreate;
        } else if (this.tabIn == 1) {
          result =
            !this.formInputDataOwnerEmpty && this.inputDataOwner.type != "";
        } else if (this.tabIn == 2) {
          result =
            !this.formInputDataOwnerEmpty &&
            !this.formModifyDataOwnerEmpty &&
            this.inputDataOwner.type != "";
        } else {
          result =
            !this.formInputDataOwnerEmpty && this.inputDataOwner.type != "";
        }
      }
      return result;
    },
    postData: function() {
      return {
        tab_out: this.tabOut.toString(),
        tab_in: this.tabIn.toString(),

        i_account_id:
          this.tabOut == 0 ? this.inputDataAccount.id : this.inputDataOwner.id,
        i_account_balance: this.inputDataAccount.balance,
        i_account_open_bank:
          this.tabOut == 0
            ? this.inputDataAccount.openBank
            : this.inputDataOwner.openBank,
        i_account_type:
          this.tabOut == 0
            ? this.inputDataAccount.type
            : this.inputDataOwner.type,
        i_account_open_date: this.inputDataAccount.openDate,
        i_account_last_visit_date: this.inputDataOwner.lastVisitDate,
        i_account_customer_id: this.inputDataOwner.customerID,
        i_account_credit: this.inputDataAccount.CheckingAccountCredit,
        i_account_rate: this.inputDataAccount.savingsAccountRate,
        i_account_currency_type: this.inputDataAccount
          .savingsAccountCurrencyType,

        m_account_id:
          this.tabOut == 0
            ? this.modifyDataAccount.id
            : this.modifyDataOwner.id,
        m_account_balance: this.modifyDataAccount.balance,
        m_account_open_bank:
          this.tabOut == 0
            ? this.modifyDataAccount.openBank
            : this.modifyDataOwner.openBank,
        m_account_type:
          this.tabOut == 0
            ? this.modifyDataAccount.type
            : this.modifyDataOwner.type,
        m_account_open_date: this.modifyDataAccount.openDate,
        m_account_last_visit_date: this.modifyDataOwner.lastVisitDate,
        m_account_customer_id: this.modifyDataOwner.customerID,
        m_account_credit: this.modifyDataAccount.CheckingAccountCredit,
        m_account_rate: this.modifyDataAccount.savingsAccountRate,
        m_account_currency_type: this.modifyDataAccount
          .savingsAccountCurrencyType
      };
    }
  },
  methods: {
    resetForm: function() {
      if (this.tabOut == 0) {
        if (this.tabIn == 2) {
          // if modify
          for (let item in this.inputDataAccount) {
            this.inputDataAccount[item] = "";
          }
          for (let item in this.modifyDataAccount) {
            this.modifyDataAccount[item] = "";
          }
        } else {
          for (let item in this.inputDataAccount) {
            this.inputDataAccount[item] = "";
          }
        }
      } else {
        if (this.tabIn == 2) {
          // if modify
          for (let item in this.inputDataOwner) {
            this.inputDataOwner[item] = "";
          }
          for (let item in this.modifyDataOwner) {
            this.modifyDataOwner[item] = "";
          }
        } else {
          for (let item in this.inputDataOwner) {
            this.inputDataOwner[item] = "";
          }
        }
      }
    },
    commitForm: function() {
      this.$axios
        .post("/account-management", this.postData)
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
