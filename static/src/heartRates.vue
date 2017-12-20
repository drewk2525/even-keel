<template>
  <div>
    <div class="dashboardActions">
      <h1>Heart Rates</h1>
      <button class="deleteButton">Delete Selected</button>
      <button class="addButton" @click="openForm">Add Heart Rate</button>
    </div>
    <v-data-table
      v-bind:headers="heartRateHeaders"
      v-bind:items="userHeartRates"
      class="mainTable"
      v-model="selected"
      item-key="HeartRateID"
      select-all
      v-bind:rows-per-page-items="defaultRowsPerPage"
      id="dashboardDataTable"
    >
      <template slot="items" scope="props">
        <td>
          <v-checkbox
            primary
            v-model="props.selected"
          ></v-checkbox>
        </td>
        <td>{{ props.item.HeartRateID }}
        </td>
        <td>{{ props.item.HeartRateTypeDescription }}</td>
        <td>{{ props.item.BPM }}</td>
        <td>{{ props.item.CreateDT | dateTime }}</td>
      </template>
    </v-data-table>
    <v-dialog v-model="heartRateModal" persistent max-width="400">
      <v-card>
        <v-card-title>Add Heart Rate</v-card-title>
        <v-select label="Type of heart rate" 
                  required
                  v-model="newHeartRate.heartRateType"
                  v-bind:items="heartRateData"
                  item-text="HeartRateTypeDescription"
                  item-value="HeartRateTypeID"
        >
        </v-select>
        <v-text-field label="Heart Rate" required v-model="newHeartRate.heartRateValue"></v-text-field>
        <v-card-actions>
          <v-btn color="primary darken-1" flat @click.native="heartRateModal = false">Cancel</v-btn>
          <v-btn color="green darken-1" flat @click="addHeartRate">Submit</v-btn>
        </v-card-actions>

      </v-card>
    </v-dialog>
  </div>
</template>


<script>
  import { generalAPICall } from '../js/api.js'
  
  export default {
    name: 'app',
    data () {
      return {
        heartRateModal: false,
        createdHeartRate: false,
        createdHeartRateError: false,
        heartRateData: [],
        selected: [],
        userHeartRates: [],
        defaultRowsPerPage:[25, 50, 100, 200],
        heartRateHeaders: [
          {
            text: 'ID',
            align: 'center',
            sortable: true,
            value: 'HeartRateID'
          },
          {
            text: 'Type', 
            align: 'center',
            sortable: true,
            value: 'HeartRateTypeDescription'
          },
          {
            text: 'BPM', 
            align: 'center',
            sortable: true,
            value: 'BPM'
          },
          {
            text: 'Date Entered', 
            align: 'center',
            sortable: true,
            value: 'CreateDT'
          }
        ],
        newHeartRate: {
          heartRateType: 1,
          heartRateValue: ''
        }
      }
    }, 
    methods: {
      addHeartRate: function(event){
        generalAPICall('addHeartRate', this.newHeartRate).then(function(data){
          if(data === false){
            this.$parent.$emit('update-alert', "Failure", "Heart rate was not added, please try again later.");
            this.heartRateModal = false;
          } else{
            generalAPICall('getUserHeartRates').then(function(data){
              this.userHeartRates = data;
            }.bind(this));
            this.$parent.$emit('update-alert', "Success", "Heart rate added successfully!");
  //          this.createdHeartRate = true;
            this.heartRateModal = false;
          }
        }.bind(this));
      },
      openForm: function(){
        this.newHeartRate = { heartRateType: 1, heartRateValue: ''}
        this.$parent.$emit('reset-alerts');
        this.heartRateModal = true;
      }
    },
    mounted: function(){
      generalAPICall('getHeartRateTypes').then(function(data){
        this.heartRateData = data;
      }.bind(this));
      generalAPICall('getUserHeartRates').then(function(data){
        this.userHeartRates = data;
      }.bind(this));
    }
  }
</script>