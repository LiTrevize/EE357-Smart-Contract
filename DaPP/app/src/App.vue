<template>
  <v-app id="sandbox">
    <v-navigation-drawer
      width='20%'
      v-model="primaryDrawer.model"
      :clipped="primaryDrawer.clipped"
      :floating="primaryDrawer.floating"
      :mini-variant="primaryDrawer.mini"
      :permanent="primaryDrawer.type === 'permanent'"
      :temporary="primaryDrawer.type === 'temporary'"
      app
      overflow
    >
    <v-container fluid>
      <h1>Control Panel</h1>
    </v-container>
    <v-expansion-panels
      multiple
      hover
      inset
      focusable
    >
      <v-expansion-panel>
        <v-tooltip bottom>
          <template v-slot:activator="{ on }">
            <v-expansion-panel-header v-on="on">
              Funding
            </v-expansion-panel-header>
          </template>
          <span>
            Funding.sol
          </span>
        </v-tooltip>
        <v-expansion-panel-content>
          <v-select 
            v-model="account"
            :items="accounts"
            label="Accounts"
          ></v-select>
          <v-text-field
            v-model="Funding.value"
            label="Support"
          ></v-text-field>
          <v-row>
            <v-col><v-btn @click="support">Support</v-btn></v-col>
            <v-col><v-btn @click="retract">Retract</v-btn></v-col>
            <v-col><v-btn @click="refund">refund</v-btn></v-col>
          </v-row>
          
          
        </v-expansion-panel-content>
      </v-expansion-panel>
      <v-expansion-panel>
        <v-tooltip bottom>
          <template v-slot:activator="{ on }">
            <v-expansion-panel-header v-on="on">
              Request
            </v-expansion-panel-header>
          </template>
          <span>
            InsuredFunding.sol
          </span>
          </v-tooltip>
          <v-expansion-panel-content>
            <v-text-field
            v-model="Insured.request"
            label="Request"
            ></v-text-field>
            <v-btn @click="postRequest">postRequest</v-btn>
            <v-btn @click="getRequest">Complete</v-btn>
          </v-expansion-panel-content>
        
      </v-expansion-panel>
      <v-expansion-panel>
        <v-tooltip bottom>
          <template v-slot:activator="{ on }">
            <v-expansion-panel-header v-on="on">
              Trade
            </v-expansion-panel-header>
          </template>
          <span>
            TradableFunding.sol
          </span>
          </v-tooltip>
          <v-expansion-panel-content>
            <v-select 
              v-model="Trade.account"
              :items="accounts"
              label="Standard"
            ></v-select>
            <v-text-field
              v-model="Trade.amount"
              label="Amount"
            ></v-text-field>
            <v-text-field
              v-model="Trade.price"
              label="Price"
            ></v-text-field>
            <v-row>
              <v-col><v-btn @click="postSale">postSale</v-btn></v-col>
              <v-col><v-btn @click="cancelSale">cancelSale</v-btn></v-col>
              <v-col><v-btn @click="buyShares">buyShare</v-btn></v-col>
            </v-row>
          </v-expansion-panel-content>
        
      </v-expansion-panel>
    </v-expansion-panels>
    </v-navigation-drawer>

    <v-card class="overflow">
    <v-app-bar
      :clipped-left="primaryDrawer.clipped"
      app
    >
      <v-app-bar-nav-icon
        v-if="primaryDrawer.type !== 'permanent'"
        @click.stop="primaryDrawer.model = !primaryDrawer.model"
      />
      <v-toolbar-title>Funding</v-toolbar-title>
      <v-tabs
        v-model="tabs.tab"
        :right="tabs.right"
      >
        <v-tab href="#tab-1">Funding</v-tab>
        <v-tab href="#tab-2">Request</v-tab>
        <v-tab href="#tab-3">Trade</v-tab>
      </v-tabs>
    </v-app-bar>
    </v-card>

    <v-content>
      <v-container fluid>
        <v-tabs-items v-model="tabs.tab">
          <v-tab-item
            value="tab-1"
          >
            <v-row>
              <v-col>
                <v-card height = '800px'>
                  <v-card-title primary-title>
                    Funding
                  </v-card-title>
                  <v-divider></v-divider>
                  <v-list>
                    <v-list-item>
                      <v-list-item-content>Funding Name</v-list-item-content>
                      <v-list-item-content class="align-end">
                        {{ this.Funding.projectName }}
                      </v-list-item-content>
                    </v-list-item>
                    <v-list-item>
                      <v-list-item-content>Start Time</v-list-item-content>
                      <v-list-item-content class="align-end">
                        {{ this.stamp2data(this.Funding.startTime) }}
                      </v-list-item-content>
                    </v-list-item>
                    <v-list-item>
                      <v-list-item-content>End Time</v-list-item-content>
                      <v-list-item-content class="align-end">
                        {{ this.stamp2data(this.Funding.endTime) }}
                      </v-list-item-content>
                    </v-list-item>
                    <v-list-item>
                      <v-list-item-content>Raised Money (wei)</v-list-item-content>
                      <v-list-item-content class="align-end">
                        {{ this.Funding.raisedMoney /  1000000000000000000 }} / {{ this.Funding.fundingGoal}} 
                      </v-list-item-content>
                    </v-list-item>
                  </v-list>
                </v-card>
              </v-col>
              <v-col>
                <v-card height = '800px'>
                  <v-card-title primary-title>
                    Record of Accounts 
                  </v-card-title>
                    <v-simple-table>
                    <thead>
                      <tr>
                        <th class="text-left">Name</th>
                        <th class="text-left">Money</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr v-for="(value, item) in Funding.record" :key="item">
                        <td>{{ item }}</td>
                        <td>{{ value / 1000000000000000000 }}</td>
                      </tr>
                    </tbody>
                  </v-simple-table>
                </v-card>
              </v-col>
            </v-row>
          </v-tab-item>
          
          <v-tab-item
            value="tab-2"
          >
          <v-row>
              <v-col>
                <v-card height = '800px'>
                  <v-card-title primary-title>
                    Request
                  </v-card-title>
                  <v-divider></v-divider>
                  <v-list>
                    <v-list-item>
                      <v-list-item-content>Start Time</v-list-item-content>
                      <v-list-item-content class="align-end">
                        {{ this.stamp2data(Insured.startTime) }}
                      </v-list-item-content>
                    </v-list-item>
                    <v-list-item>
                      <v-list-item-content>End Time</v-list-item-content>
                      <v-list-item-content class="align-end">
                        {{ this.stamp2data(Insured.endTime) }}
                      </v-list-item-content>
                    </v-list-item>
                    <v-list-item>
                      <v-list-item-content>Amoumnt (wei)</v-list-item-content>
                      <v-list-item-content class="align-end">
                        {{ Insured.amount }} 
                      </v-list-item-content>
                    </v-list-item>
                    <v-list-item>
                      <v-list-item-content>Vote</v-list-item-content>
                      <v-list-item-content class="align-end">
                        {{ Insured.select.length }} 
                      </v-list-item-content>
                    </v-list-item>
                    <v-list-item>
                      <v-list-item-content>Veto</v-list-item-content>
                      <v-list-item-content class="align-end">
                        {{ accounts.length - Insured.select.length }} 
                      </v-list-item-content>
                    </v-list-item>
                  </v-list>
                </v-card>
              </v-col>
              <v-col>
                <v-card height = '800px'>
                  <v-list-item-group
                    v-model="Insured.select"
                    multiple
                    active-class=""
                  >
                    <v-list-item v-for="account in accounts" :key="account">
                      <template v-slot:default="{ active }">
                        <v-list-item-action>
                          <v-checkbox :input-value="active"></v-checkbox>
                        </v-list-item-action>
                        <v-list-item-content>
                          <v-list-item-title>{{ account }}</v-list-item-title>
                        </v-list-item-content>
                      </template>
                    </v-list-item>
                  </v-list-item-group>
                  <v-row>
                    <v-col><v-btn>Vote</v-btn></v-col>
                  </v-row>
                </v-card>
              </v-col>
            </v-row>
        
          </v-tab-item>
          <v-tab-item 
            value="tab-3"
          >
            <v-list-item-group
              v-model="Trade.select"
              multiple
              active-class=""
            >
              <v-list-item v-for="sale in Trade.sales" :key="sale.id">
                <template v-slot:default="{ active }">
                  <v-list-item-action>
                    <v-checkbox :input-value="active"></v-checkbox>
                  </v-list-item-action>
                  <v-list-item-content>
                    <v-list-item-title>Address: {{ sale.address }}</v-list-item-title>
                    <v-list-item-subtitle>Amount: {{ sale.amount / 1000000000000000000 }} wei, Price: {{ sale.price / 1000000000000000000 }} wei</v-list-item-subtitle>
                  </v-list-item-content>
                </template>
              </v-list-item>
            </v-list-item-group>
          </v-tab-item>
        </v-tabs-items>
      </v-container>
    </v-content>


    <v-footer
      :inset="footer.inset"
      app
    >
      <span class="px-4">&copy; {{ new Date().getFullYear() }}</span>
    </v-footer>
  </v-app>
</template>

<script>
//import HelloWorld from './components/HelloWorld.vue'
import Web3 from "web3";
import metaFundingArtifact from "../../build/contracts/TradableFunding.json";

export default {
  name: 'App',
  data: () => ({
    tabs:{
      right: true,
      tab: 'tab-1',
    },
    footer: {
      inset: true,
    },
    primaryDrawer: {
      model: null,
      type: 'default (no property)',
      clipped: false,
      floating: false,
      mini: false,
    },
    Funding: {
      raisedMoney: 0,
      record: {},
      value: 0,
      FundingGoal: null,
      projectName: null,
      startTime: null,
      endTime: null,
      
    },
    Insured: {
      select: [],
      request: null,
      amount: null,
      startTime: null,
      endTime: null,
      numVote: null,
      numVeto: null,
    },
    Trade: {
      account: null,
      amount: null,
      price: null,
      sales: [],
      select: [],
      id: 0,
    },
    meta: null,
    web3: null,
    account: null,
    accounts: [],
    manager: null,
  }),
  methods: {
    stamp2data(stamp) {
      const newDate = new Date();
      newDate.setTime(stamp * 1000);
      return newDate.toLocaleString();
    },
    /* Funding */
    retract() {
      const { retract } = this.meta.methods;
      retract(this.web3.utils.toWei(this.Funding.value,"ether")).send({from: this.account}).then(res => {
        console.log(this.account);
        this.getSupport(this.account);
        this.getRaisedMoney();
      })
    },
    support() {
      const { support } = this.meta.methods;
      support().send({from: this.account, value: this.web3.utils.toWei(this.Funding.value,"ether"), gas: "220000"}).then(value => {
        console.log(value);
        this.getRaisedMoney();
        this.getSupport(this.account);
      })
    },
    getSupport(account) {
      const { getMySupport } = this.meta.methods;
      //console.log(account);
      getMySupport().call({from: account}).then(res =>{
        this.Funding.record[account] = res;
      })
    },
    getRaisedMoney() {
      const { getBalance } = this.meta.methods;
      getBalance().call().then(balance => {
        this.Funding.raisedMoney = balance;
      })
    },
    refund() {
      const { refund } = this.meta.methods;
      refund().call();
    },
    /* Vote */
    getRequest() {
      const { requests } = this.meta.methods;
      requests(0).call().then(res => {
        console.log(res);
        console.log(res.startTime);
        this.Insured.startTime = res.startTime;
        this.Insured.endTime = res.endTime;
        this.Insured.amount = res.amount;
        this.Insured.vote = res.numVote;
        this.Insured.veto = res.numVeto;
        console.log(this.Insured);
      });
    },
    postRequest() {
      const { postRequest } = this.meta.methods;
      console.log(this.manager);
      console.log(this.Insured.request);
      postRequest(this.Insured.request,1000).send({from: this.manager}).then(res => {
        this.getRequest();
        console.log(res);
      },
      err => {
        console.log(err);
      });
    },
    vote() {
      const { vote } = this.meta.methods;
      vote(true).send({from: this.accounts[0]}).then(res => {
        console.log("hello");
      }, 
      err => {
        console.log(err);
      });
    },
    /* Trade */
    postSale() {
      const { postSale } = this.meta.methods;
      const amount = this.web3.utils.toWei(this.Trade.amount.toString(),"ether");
      const price = this.web3.utils.toWei(this.Trade.price.toString(),"ether")
      postSale(amount , price).send({from: this.Trade.account}).then(res => {
        console.log("yes");
        this.getSale(this.Trade.account);
      },
      err => {
        console.log(err);
      });
    },
    getSale(address) {
      const { sales } = this.meta.methods;
      sales(address).call().then(res => {
        if(res["amount"] == 0)  return;
        res["id"] = this.Trade.id;
        res["address"] = address;
        this.Trade.id++;
        this.Trade.sales.push(res);
      })
    },
    cancelSale() {
      const address = this.Trade.account;
      const { cancelSale } = this.meta.methods;
      cancelSale().send({ from:  address}).then(res => {
        console.log("Sale Cancel!");
      });
      for(let i in this.Trade.sales)
      {
         if(this.Trade.sales[i].address == address)
         {
           console.log(i);
           this.Trade.sales.splice(i,1);
           console.log(this.Trade.sales);
           break;
         }
      }
    },
    buyShares() {
      for(let i of this.Trade.select)
      {
        //console.log(i);
        const sale = this.Trade.sales[i];
        //console.log(sale);
        this.buyShare(sale.address, sale.price);
      }
    },
    buyShare(address, price) {
      const { buyShare } = this.meta.methods;
      console.log(price);
      buyShare(address).send({from: this.Trade.account, value: price}).then(res=>{
        this.getSupport(address);
        this.getSupport(this.Trade.account);
      },err=>{
        console.log(err);
      });
      
    },
    test(){
      this.getSale(this.accounts[1]);
      this.buyShare(this.accounts[1]);
    }
  },
  created() {
    const provider = new Web3.providers.HttpProvider("http://localhost:9545");
    this.web3 = new Web3(provider);
    this.web3.eth.net.getId().then(networkId => {
      console.log(networkId);
      const deployedNetwork = metaFundingArtifact.networks[networkId];
      this.meta = new this.web3.eth.Contract(
        metaFundingArtifact.abi,
        deployedNetwork.address,
      );
      console.log(this.meta);
      this.meta.methods.projectName().call().then(name => {
        this.Funding.projectName = name;
        console.log(name);
      });
      this.meta.methods.startTime().call().then(time => {
        this.Funding.startTime = time;
        console.log(time);
      });
      this.meta.methods.endTime().call().then(time => {
        this.Funding.endTime = time;
        console.log(time);
      });
      this.meta.methods.fundingGoal().call().then(goal => {
        this.Funding.fundingGoal = goal;
        console.log(goal);
      });
      this.getRaisedMoney(); 
      this.meta.methods.manager().call().then(res => {
        console.log(res);
        this.manager = res;
      });
      //this.getRequest();
      this.web3.eth.getAccounts().then(accounts => {
        //console.log(acc);
        console.log(accounts);
        this.accounts = accounts;
        this.account = accounts[0];
        for (let i in accounts)
        {
          console.log(accounts[i]);
          this.getSupport(accounts[i]);
          this.getSale(accounts[i]);
        }
        console.log(this.Funding.record);
      });
      //const event = this.meta.events.transfer();
      /*
      this.meta.methods.manager().call().then(res => {
        console.log(res);
        console.log(this.meta._address);
      });
      */
    });
    
  },
  
}


</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
