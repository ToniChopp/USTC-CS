<template>
  <v-container>
    <!-- <v-row align="center" justify="center" class="display-1 py-4">Customer Management</v-row> -->
    <v-row>
      <v-col>
        <v-card flat>
          <v-tabs fixed-tabs v-model="tab">
            <v-tab v-for="(op, idx) in operations" :key="idx">{{ op }}</v-tab>
          </v-tabs>
          <v-tabs-items v-model="tab">
            <v-tab-item v-for="(op, idx) in operations" :key="idx">
              <v-card outlined class="my-4 px-4">
                <v-card-title>{{ cardOneTitle[idx] }}</v-card-title>
                <v-form>
                  <v-row>
                    <v-col cols="4">
                      <v-text-field
                        v-model="inputData.id"
                        counter="18"
                        label="ID"
                        outlined
                        dense
                        :rules="[v => (v == '' || /^[+]{0,1}(\d+)$|^[+]{0,1}(\d+\.\d+)$/.test(v) || 'Invalid input!')]"
                      ></v-text-field>
                    </v-col>
                    <v-col cols="2">
                      <v-text-field
                        v-model="inputData.name"
                        counter="10"
                        label="姓名"
                        outlined
                        dense
                      ></v-text-field>
                    </v-col>
                    <v-col cols="4">
                      <v-text-field
                        v-model="inputData.phone"
                        counter="11"
                        label="电话号码"
                        outlined
                        dense
                        :rules="[v => (v == '' || /^[+]{0,1}(\d+)$|^[+]{0,1}(\d+\.\d+)$/.test(v) || 'Invalid input!')]"
                      ></v-text-field>
                    </v-col>
                  </v-row>
                  <v-row>
                    <v-col cols="6">
                      <v-text-field
                        v-model="inputData.address"
                        counter="50"
                        label="家庭住址"
                        outlined
                        dense
                      ></v-text-field>
                    </v-col>
                  </v-row>
                  <v-row>
                    <v-col cols="2">
                      <v-text-field
                        v-model="inputData.contactName"
                        counter="10"
                        label="联系人姓名"
                        outlined
                        dense
                      ></v-text-field>
                    </v-col>
                    <v-col cols="4">
                      <v-text-field
                        v-model="inputData.contactPhone"
                        counter="11"
                        label="联系人电话"
                        outlined
                        dense
                        :rules="[v => (v == '' || /^[+]{0,1}(\d+)$|^[+]{0,1}(\d+\.\d+)$/.test(v) || 'Invalid input!')]"
                      ></v-text-field>
                    </v-col>
                  </v-row>
                  <v-row>
                    <v-col cols="4">
                      <v-text-field
                        v-model="inputData.contactEmail"
                        counter="20"
                        label="联系人邮箱"
                        outlined
                        dense
                      ></v-text-field>
                    </v-col>
                    <v-col cols="2">
                      <v-text-field
                        v-model="inputData.contactRelationship"
                        counter="10"
                        label="与客户关系"
                        outlined
                        dense
                      ></v-text-field>
                    </v-col>
                  </v-row>
                  <v-row>
                    <v-col cols="2">
                      <v-text-field
                        v-model="inputData.loanStaffID"
                        counter="10"
                        label="贷款负责人"
                        outlined
                        dense
                      ></v-text-field>
                    </v-col>
                    <v-col cols="2">
                      <v-text-field
                        v-model="inputData.accountStaffID"
                        counter="10"
                        label="账户负责人"
                        outlined
                        dense
                      ></v-text-field>
                    </v-col>
                  </v-row>
                </v-form>
              </v-card>
              <v-card outlined class="my-4 px-4" v-if="idx==2">
                <v-card-title>更新后的用户信息</v-card-title>
                <v-form>
                  <v-row>
                    <v-col cols="4">
                      <v-text-field
                        v-model="modifyData.id"
                        counter="18"
                        label="ID"
                        outlined
                        dense
                        :rules="[v => (v == '' || /^[+]{0,1}(\d+)$|^[+]{0,1}(\d+\.\d+)$/.test(v) || 'Invalid input!')]"
                      ></v-text-field>
                    </v-col>
                    <v-col cols="2">
                      <v-text-field
                        v-model="modifyData.name"
                        counter="10"
                        label="姓名"
                        outlined
                        dense
                      ></v-text-field>
                    </v-col>
                    <v-col cols="4">
                      <v-text-field
                        v-model="modifyData.phone"
                        counter="11"
                        label="电话号码"
                        outlined
                        dense
                        :rules="[v => (v == '' || /^[+]{0,1}(\d+)$|^[+]{0,1}(\d+\.\d+)$/.test(v) || 'Invalid input!')]"
                      ></v-text-field>
                    </v-col>
                  </v-row>
                  <v-row>
                    <v-col cols="6">
                      <v-text-field
                        v-model="modifyData.address"
                        counter="50"
                        label="家庭住址"
                        outlined
                        dense
                      ></v-text-field>
                    </v-col>
                  </v-row>
                  <v-row>
                    <v-col cols="2">
                      <v-text-field
                        v-model="modifyData.contactName"
                        counter="10"
                        label="联系人姓名"
                        outlined
                        dense
                      ></v-text-field>
                    </v-col>
                    <v-col cols="4">
                      <v-text-field
                        v-model="modifyData.contactPhone"
                        counter="11"
                        label="联系人电话"
                        outlined
                        dense
                        :rules="[v => (v == '' || /^[+]{0,1}(\d+)$|^[+]{0,1}(\d+\.\d+)$/.test(v) || 'Invalid input!')]"
                      ></v-text-field>
                    </v-col>
                  </v-row>
                  <v-row>
                    <v-col cols="4">
                      <v-text-field
                        v-model="modifyData.contactEmail"
                        counter="20"
                        label="联系人邮箱"
                        outlined
                        dense
                      ></v-text-field>
                    </v-col>
                    <v-col cols="2">
                      <v-text-field
                        v-model="modifyData.contactRelationship"
                        counter="10"
                        label="与客户关系"
                        outlined
                        dense
                      ></v-text-field>
                    </v-col>
                  </v-row>
                  <v-row>
                    <v-col cols="2">
                      <v-text-field
                        v-model="modifyData.loanStaffID"
                        counter="10"
                        label="贷款负责人"
                        outlined
                        dense
                      ></v-text-field>
                    </v-col>
                    <v-col cols="2">
                      <v-text-field
                        v-model="modifyData.accountStaffID"
                        counter="10"
                        label="账户负责人"
                        outlined
                        dense
                      ></v-text-field>
                    </v-col>
                  </v-row>
                </v-form>
              </v-card>
              <v-card flat class="my-4 px-4">
                <v-row>
                  <v-col cols="2" offset="4">
                    <v-btn :disabled="!commitBtnValid" color="success" @click="commitForm">确认</v-btn>
                  </v-col>
                  <v-col cols="2">
                    <v-btn :disabled="!resetBtnValid" color="warning" @click="resetForm">清空</v-btn>
                  </v-col>
                </v-row>
              </v-card>
              <v-divider class="py-2"></v-divider>

              <v-card flat v-if="idx!=3 && receiveData != '' && receiveData.tab==idx">
                <v-card-title>{{ cardStatusTitle[idx] }}</v-card-title>
                <v-card-text>
                  {{ receiveData.message }}
                </v-card-text>
              </v-card>

              <v-card flat v-if="idx==3 && receiveData != '' && receiveData.tab==idx">
                <v-card-title>{{ cardStatusTitle[idx] }}</v-card-title>
                <v-card-text>
                  {{ receiveData.message }}
                </v-card-text>

                <v-simple-table>
                  <template v-slot:default>
                    <thead>
                      <tr>
                        <th class="text-left">Index</th>
                        <th class="text-left">Customer ID</th>
                        <th class="text-left">Customer Name</th>
                        <th class="text-left">Customer Phone</th>
                        <th class="text-left">Customer Address</th>
                        <th class="text-left">Contact Name</th>
                        <th class="text-left">Contact Phone</th>
                        <th class="text-left">Contact Email</th>
                        <th class="text-left">Contact Relationship</th>
                        <th class="text-left">Loan Staff ID</th>
                        <th class="text-left">Account Staff ID</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr v-for="(ds, index) in receiveData.data" :key="index">
                        <td>{{ index }}</td>
                        <td>{{ ds.customer_id }}</td>
                        <td>{{ ds.customer_name }}</td>
                        <td>{{ ds.customer_phone }}</td>
                        <td>{{ ds.customer_address }}</td>
                        <td>{{ ds.contact_name }}</td>
                        <td>{{ ds.contact_phone }}</td>
                        <td>{{ ds.contact_email }}</td>
                        <td>{{ ds.contact_relationship }}</td>
                        <td>{{ ds.loan_staff_id }}</td>
                        <td>{{ ds.account_staff_id }}</td>
                      </tr>
                    </tbody>
                  </template>
                </v-simple-table>
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
  name: "CustomerManage",
  data: () => ({
    tab: 0,
    operations: ["创建", "删除", "更改", "查询"],
    cardOneTitle: [
      "需要创建的用户的信息",
      "需要删除的用户的信息",
      "更新前的用户信息",
      "需要搜索的用户信息"
    ],
    cardStatusTitle: [
      "创建用户结果",
      "删除用户结果",
      "更新用户结果",
      "搜索用户结果"
    ],
    inputData: {
      id: "",
      name: "",
      phone: "",
      address: "",
      loanStaffID: "",
      accountStaffID: "",
      contactName: "",
      contactPhone: "",
      contactEmail: "",
      contactRelationship: ""
    },
    modifyData: {
      id: "",
      name: "",
      phone: "",
      address: "",
      loanStaffID: "",
      accountStaffID: "",
      contactName: "",
      contactPhone: "",
      contactEmail: "",
      contactRelationship: ""
    },
    receiveData: ""
  }),
  computed: {
    formOneEmpty: function() {
      let result = this.inputData["id"].length == 0;
      for (let item in this.inputData) {
        result = result && this.inputData[item].length == 0;
      }
      return result;
    },
    formTwoEmpty: function() {
      let result = this.modifyData["id"].length == 0;
      for (let item in this.modifyData) {
        result = result && this.modifyData[item].length == 0;
      }
      return result;
    },
    checkFormOneCreate: function() {
      let result = true;
      for (let item in this.inputData) {
        if (item == "loanStaffID" || item == "accountStaffID") {
          continue;
        }
        result = result && this.inputData[item] != "";
      }
      return result;
    },
    resetBtnValid: function() {
      let result = false;
      if (this.tab == 2) {
        // if modify
        result = !this.formOneEmpty || !this.formTwoEmpty;
      } else {
        result = !this.formOneEmpty;
      }
      return result;
    },
    commitBtnValid: function() {
      let result = false;
      if (this.tab == 0) {
        // if modify
        result = this.checkFormOneCreate;
      } else if (this.tab == 1) {
        result = !this.formOneEmpty;
      } else if (this.tab == 2) {
        result = !this.formOneEmpty && !this.formTwoEmpty;
      } else {
        result = !this.formOneEmpty;
      }
      return result;
    },
    postData: function() {
      let result = {
        tab: this.tab.toString(),
        customer_id: this.inputData.id,
        customer_name: this.inputData.name,
        customer_phone: this.inputData.phone,
        customer_address: this.inputData.address,
        contact_name: this.inputData.contactName,
        contact_phone: this.inputData.contactPhone,
        contact_email: this.inputData.contactEmail,
        contact_relationship: this.inputData.contactRelationship,
        loan_staff_id: this.inputData.loanStaffID,
        account_staff_id: this.inputData.accountStaffID,
        m_customer_id: this.modifyData.id,
        m_customer_name: this.modifyData.name,
        m_customer_phone: this.modifyData.phone,
        m_customer_address: this.modifyData.address,
        m_contact_name: this.modifyData.contactName,
        m_contact_phone: this.modifyData.contactPhone,
        m_contact_email: this.modifyData.contactEmail,
        m_contact_relationship: this.modifyData.contactRelationship,
        m_loan_staff_id: this.modifyData.loanStaffID,
        m_account_staff_id: this.modifyData.accountStaffID
      };
      return result;
    }
  },
  methods: {
    resetForm: function() {
      for (let item in this.inputData) {
        this.inputData[item] = "";
      }
    },
    commitForm: function() {
      this.$axios
        .post("/customer-management", this.postData)
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