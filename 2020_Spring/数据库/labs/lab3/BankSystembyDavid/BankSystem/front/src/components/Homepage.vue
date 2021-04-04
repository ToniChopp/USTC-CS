<template>
  <v-container>
    <v-row>
      <v-col cols="8" offset="2" align="space-around">
        <h1 justify="center" class="py-12 display-5">银行分行与职员介绍</h1>

        <v-card outlined class="my-4 px-4" v-for="(dType, idxType) in dataType" :key="idxType">
          <v-card-title>{{ dataType[idxType] }}</v-card-title>
          <v-simple-table>
            <template v-slot:default>
              <thead>
                <tr>
                  <th
                    class="text-middle"
                    v-for="(dLabel, idxLabel) in label[idxType]"
                    :key="idxLabel"
                  >{{ dLabel }}</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(dOut, idxOut) in data[idxType]" :key="idxOut">
                  <td v-for="(dIn, idxIn) in dOut" :key="idxIn">{{ dIn }}</td>
                </tr>
              </tbody>
            </template>
          </v-simple-table>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {
  name: "Welcome",

  data: () => ({
    dataType: ["网点分布", "职员介绍", "部门介绍", "部门经理介绍"],
    label: [
      ["分行名", "城市"],
      [
        "员工 ID",
        "姓名",
        "联系方式",
        "家庭住址",
        "开始工作日期",
        "部门 ID"
      ],
      [
        "部门 ID",
        "部门名",
        "类型",
        "部门经理",
        "所属分行"
      ],
      ["员工 ID", "部门 ID"]
    ],
    data: [
      [
        ["北京分行", "北京"],
        ["上海分行", "上海"],
        ["合肥分行", "合肥"],
        ["广州分行", "广州"],
        ["深圳分行", "深圳"]
      ],
      [
        ["staff_1",
        "staffA",
        "13312312345",
        "合肥市蜀山区",
        "2012-01-11",
        "depart_1"],
        ["staff_2",
        "staffB",
        "13323323333",
        "芝加哥南区",
        "2020-01-10",
        "depart_2"],
        ["staff_3",
        "staffC",
        "13323311451",
        "芝加哥北区",
        "2020-01-10",
        "depart_3"],
        ["staff_4",
        "staffD",
        "17344455555",
        "华莱士大街",
        "2020-01-10",
        "depart_4"],
        ["staff_5",
        "staffE",
        "18912345678",
        "合肥市包河区",
        "2018-01-31",
        "depart_5"],
        ["staff_6",
        "staffF",
        "13012345678",
        "合肥市包河区",
        "2018-03-22",
        "depart_2"],
        ["staff_7",
        "staffG",
        "18900011100",
        "合肥市蜀山区",
        "2018-10-31",
        "depart_3"],
        ["staff_8",
        "staffH",
        "18912321232",
        "巢湖",
        "2020-01-31",
        "depart_6"]
      ],
      [
        ["depart_1", "市场部", "普通", "staff_1", "Beijing Bank"],
        ["depart_2", "市场部", "普通", "staff_2", "Beijing Bank"],
        ["depart_3", "市场部", "特殊", "staff_3", "Shanghai Bank"],
        ["depart_4", "人事部", "普通", "staff_4", "Nanjing Bank"],
        ["depart_5", "人事部", "普通", "staff_5", "Hefei Bank"]
      ],
      [
        ["staff_1", "depart_1"],
        ["staff_2", "depart_2"],
        ["staff_3", "depart_3"],
        ["staff_4", "depart_4"],
        ["staff_5", "depart_5"]
      ]
    ]
  })
};
</script>
