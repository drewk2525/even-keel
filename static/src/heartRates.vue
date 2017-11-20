<template>
  <div>
    <v-dialog v-model="heartRateModal" persistent max-width="400">
      <v-btn color="primary" dark slot="activator" @click="resetForm">Add Heart Rate</v-btn>
      <v-card>
        <v-card-title>Add Heart Rate</v-card-title>
<!--
        <form v-on:submit.prevent="addHeartRate">
          <fieldset>
            <label for="heart-rate-type">Type of heart rate:</label>
            <select name="heart-rate-type" v-model="newHeartRate.heartRateType">
              <option v-for="hr in heartRateData" v-bind:value="hr[0]">{{ hr[1] }}</option>
            </select>
            <label for="heart-rate-value">HeartRate:</label>
            <input type="text" name="heart-rate-value" placeholder="BPM" v-model="newHeartRate.heartRateValue"><br>
          </fieldset>
        </form>
-->
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
<!--
            <v-alert success v-model="createdHeartRate">Successfully submitted Heart Rate</v-alert>
            <v-alert error v-model="createdHeartRateError">There was an error submitting your Heart Rate.  Please try again later.</v-alert>
-->

      </v-card>
    </v-dialog>
    <v-data-table
        v-bind:headers="heartRateHeaders"
        v-bind:items="userHeartRates"
        class="mainTable"
        v-model="selected"
        item-key="HeartRateID"
        select-all
        v-bind:rows-per-page-items="defaultRowsPerPage"
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
      resetForm: function(){
        this.newHeartRate = { heartRateType: 1, heartRateValue: ''}
        this.$parent.$emit('reset-alerts');
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