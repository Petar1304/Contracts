const { ethers } = require("hardhat");

async function() {
    const MarketPlace = await ethers.getContractFactory("MarketPlace");
    const marketplace = await MarketPlace.deploy();
    await marketplace.deployed();
  
    console.log('Marketplace deployed at:'+ marketplace.address)

    await marketplace.create("item1");
    await marketplace.create("item2");
    await marketplace.create("item3");

    const filter = marketplace.filters.CreateItem(null, null, null);

    const res = await marketplace.queryFilter(filter);

    res.map(r => {
        const e = r.args;
      
        console.log('Id: ', e.id.toString());
        console.log('Owner: ', e.from);
        console.log('Data: ', e.data);
    });
}
