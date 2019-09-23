<template>
  <div class="hello">
    <h1>Prayer Cycle</h1>
    <p>
      The Prayer Cycle is a simple tool for practicing prayer. You can use it by
      yourself, and you can share it with any follower. In just 12 simple steps
      - 5 minutes each - this Prayer Cycle guides you through twelve ways the
      Bible teaches us to pray. At the end, you’ll have prayed for an hour.
    </p>

    <button class="button" v-if="!started" @click="start" style=" background-color: #215a8e;" >Start Prayer Cycle</button>
    <button class="button" v-else @click="pause" style=" background-color: white; color: black">Pause</button>

    <div v-if="!finished">
      <p>Time Elapsed: {{ formatElapsed() }} Minutes</p>
<!--      <p>current active {{ currentActive }}</p>-->
      <div class="step" v-for="(step, index) in steps" :key="index" :class="{'active' : currentActive === index}" @click="stepClicked(index)">
        <div>
          <strong>{{ step.name }} ({{ timeRemainingInStep(index) }} mins left)</strong>
        </div>
          <p v-show="showDescription(index)">{{ step.description }}</p>
      </div>
    </div>
    <div v-else style="padding: 20px">
      <strong>You are finished. Well done</strong>
    </div>
  </div>
</template>

<script>
export default {
  name: "HelloWorld",
  props: {
    msg: String
  },
  data() {
    return {
      steps: [
        {
          name: "PRAISE",
          description:
            "Start your prayer hour by praising the Lord. Praise Him for things that are on your mind right now. Praise Him for one special thing He has done in your life in the past week. Praise Him for His goodness to your family.",
          active: false
        },
        {
          name: "WAIT",
          description:
            "Spend time waiting on the Lord. Be silent and let Him pull together reflections for you.",
          active: false
        },
        {
          name: "CONFESS",
          description:
            "Ask the Holy Spirit to show you anything in your life that might be displeasing to Him. Ask Him to point out attitudes that are wrong, as well as specific acts for which you have not yet made a prayer of confession. Now confess that to the Lord so that you might be cleansed.",
          active: false
        },
        {
          name: "READ THE WORD",
          description: "Spend time reading in the Psalms, in the prophets, and passages on prayer located in the New Testament.",
          active: false
        },
        {
          name: "ASK",
          description: "Make requests on behalf of yourself.",
          active: false
        },
        {
          name: "INTERCESSION",
          description: "Make requests on behalf of others.",
          active: false
        },
        {
          name: "PRAY THE WORD",
          description: "Pray specific passages. Scriptural prayers as well as a number of psalms lend themselves well to this purpose.",
          active: false
        },
        {
          name: "THANK",
          description: "Give thanks to the Lord for the things in your life, on behalf of your family, and on behalf of your church.",
          active: false
        },
        {
          name: "SING",
          description: "Sing songs of praise or worship or another hymn or spiritual song.",
          active: false
        },
        {
          name: "MEDITATE",
          description: "Ask the Lord to speak to you. Have a pen and paper ready to record impressions He gives you.",
          active: false
        },
        {
          name: "LISTEN",
          description: "Spend time merging the things you have read, things you have prayed and things you have sung and see how the Lord brings them all together to speak to you.",
          active: false
        },
        {
          name: "PRAISE",
          description: "Praise the Lord for the time you have had to spend with Him and the impressions He has given you. Praise Him for His glorious attributes.",
          active: false
        }
      ],

      timeStarted: null,
      timeElapsed: 0,
      started: false,
      finished: false
    };
  },
  methods: {
    init() {
      setInterval(() => {
        if (this.started) {
          // this.timeStarted -= 60 * 1000;
          this.timeElapsed = Date.now() - this.timeStarted;
        }
      }, 1000 * 10);
    },
    start() {
      this.finished = false;
      this.started = true;
      this.timeStarted = Date.now() - this.timeElapsed;
    },
    pause() {
      this.started = false;
    },
    formatElapsed() {
      let active = Math.floor(this.timeElapsed / 60000 / 5);
      if (active >= this.steps.length) {
        this.finished = true;
        this.started = false;
        this.timeStarted = 0;
        this.timeElapsed = 0;
      }
      return Math.floor(this.timeElapsed / 60000);
    },
    timeRemainingInStep(index) {
      if (index < this.currentActive) {
        return 0;
      } else if (index === this.currentActive) {
        return 5 - (Math.floor(this.timeElapsed / 60000) % 5);
      } else {
        return 5;
      }
    },
    showDescription(index){
      return this.currentActive === index || this.steps[index].active;
    },
    stepClicked(index){
      this.steps[index].active = !this.steps[index].active;
    }
  },
  mounted() {
    this.init();
  },
  computed: {
    currentActive() {
      return Math.floor(this.timeElapsed / 60000 / 5);
    }
  }
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
.step {
  background-color: #eeeeee;
  padding: 15px;
}
.step.active{
  color:white;
  background-color: #3f8e5b;
}
.button {
  padding:15px;
  border-radius: 5px;
  color:white
}
</style>
