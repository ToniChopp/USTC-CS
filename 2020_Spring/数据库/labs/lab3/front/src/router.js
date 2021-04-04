import Vue from 'vue';
import Router from 'vue-router';
import Welcome from '@/components/Homepage'
import AccountManage from '@/components/AccountManage';
import BusinessStatistic from '@/components/BusinessStatistic';
import CustomerManage from '@/components/CustomerManage';
import LoanManage from '@/components/LoanManage';
import PageNotFound from '@/components/PageNotFound';
// import Page from '@/components/Page';

Vue.use(Router);

export default new Router({
  mode: 'hash',
  routes: [
    {
      path: '/',
      name: 'Welcome',
      component: Welcome
    },
    {
      path: '/account-manage',
      name: 'AccountManage',
      component: AccountManage
    },
    {
      path: '/business-statistic',
      name: 'BusinessStatistic',
      component: BusinessStatistic
    },
    {
      path: '/customer-manage',
      name: 'CustomerManage',
      component: CustomerManage
    },
    {
      path: '/loan-manage',
      name: 'LoanManage',
      component: LoanManage
    },
    {
      path: '/*',
      name: 'PageNotFound',
      component: PageNotFound
    }
  ]
});
