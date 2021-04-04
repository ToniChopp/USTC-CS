<template>
  <v-app>
    <v-navigation-drawer v-model="drawer" app color="blue">
      <v-list dense>
        <v-list-item v-for="item in drawerData" :key="item.title" link :to="item.targetPath" color="white">
          <v-list-item-icon>
            <v-icon>{{ item.icon }}</v-icon>
          </v-list-item-icon>

          <v-list-item-content>
            <v-list-item-title>{{ item.title }}</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>

    <v-app-bar app color="darkgrey" dark>
      <v-app-bar-nav-icon @click.stop="drawer = !drawer"></v-app-bar-nav-icon>
      <v-toolbar-title>银行业务管理系统</v-toolbar-title>
    </v-app-bar>

    <v-content>
      <router-view></router-view>
    </v-content>
  </v-app>
</template>

<script>
export default {
  name: "App",

  // components: {
  //   HelloWorld,
  // },

  data: () => ({
    drawer: null,
    drawerData: [
      {
        title: "银行主页",
        targetPath: "/"
      },
      {
        title: "客户管理页",
        targetPath: "/customer-manage"
      },
      {
        title: "账户管理页",
        targetPath: "/account-manage"
      },
      {
        title: "贷款管理页",
        targetPath: "/loan-manage"
      },
      {
        title: "业务统计页",
        targetPath: "/business-statistic"
      }
    ]
  })
};
</script>
