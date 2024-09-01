import { expect } from "chai";
const { ethers } = require('hardhat');


describe("SimpleMintBurnToken", function () {

    async function deploySimpleMintBurnTokenFixture() {
        const [owner, consumer1, consumer2, consumer3, provider] = await ethers.getSigners();
        
        const simpleMintBurnFactory = await ethers.getContractFactory("SimpleMintBurnToken");
        const simpleMintBurnToken = await simpleMintBurnFactory.connect(owner).deploy();

        await simpleMintBurnToken.connect(owner).mint(consumer1.address, 100);
        expect(await simpleMintBurnToken.balanceOf(consumer1.address)).to.equal(100);

        await simpleMintBurnToken.connect(owner).mint(consumer2.address, 100);
        expect(await simpleMintBurnToken.balanceOf(consumer2.address)).to.equal(100);

        await simpleMintBurnToken.connect(owner).mint(consumer3.address, 100);
        expect(await simpleMintBurnToken.balanceOf(consumer3.address)).to.equal(100);

        expect(await simpleMintBurnToken.balanceOf(provider.address)).to.equal(0);
        
        return { simpleMintBurnToken, owner, consumer1, consumer2, consumer3, provider };
    }

    describe("payService", function () {
        it("Should correctly pay for service", async function () {
            const { simpleMintBurnToken, owner, consumer1, consumer2, consumer3, provider } = await deploySimpleMintBurnTokenFixture();

            expect(await simpleMintBurnToken.balanceOf(consumer1.address)).to.equal(100);
            expect(await simpleMintBurnToken.balanceOf(consumer2.address)).to.equal(100);
            expect(await simpleMintBurnToken.balanceOf(consumer3.address)).to.equal(100);
            expect(await simpleMintBurnToken.balanceOf(provider.address)).to.equal(0);

            await simpleMintBurnToken.connect(consumer1).payService(10, provider.address);
            await simpleMintBurnToken.connect(consumer2).payService(20, provider.address);
            await simpleMintBurnToken.connect(consumer3).payService(30, provider.address);

            expect(await simpleMintBurnToken.balanceOf(consumer1.address)).to.equal(90);
            expect(await simpleMintBurnToken.balanceOf(consumer2.address)).to.equal(80);
            expect(await simpleMintBurnToken.balanceOf(consumer3.address)).to.equal(70);

            //await simpleMintBurnToken.connect(provider).claimRewards();

            //expect(await simpleMintBurnToken.balanceOf(provider.address)).to.equal(60);
        });
    });
});
